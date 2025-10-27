# Example: Windows Jump Host for prod-example Testing
# This example deploys a Windows jump host into an existing VPC to enable
# testing and configuration of AVE/DDVE instances deployed by prod-example.
#
# Prerequisites:
#   1. Deploy prod-example first
#   2. Get VPC ID and backup_internal_sg_id from prod-example outputs
#   3. Configure this example with those values
#
# Architecture:
#   - Creates new public subnet in existing VPC
#   - Creates/references Internet Gateway
#   - Deploys Windows Server 2022 jump host with public IP
#   - Jump host can access AVE/DDVE via private IPs (VPC local routing)

# Data sources
data "aws_region" "current" {}

# Reference existing VPC (same VPC used by prod-example)
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Get current public IP for RDP access
data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  my_public_ip = chomp(data.http.my_public_ip.response_body)
  rdp_cidr     = var.allowed_rdp_cidr != null ? var.allowed_rdp_cidr : "${local.my_public_ip}/32"
}

# Get Windows Server 2022 Base AMI
data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnet for jump host
resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone != null ? var.availability_zone : data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name      = "${var.deployment_name}-jumphost-public-subnet"
      ManagedBy = "Terraform"
      Type      = "Public"
      Purpose   = "Jump Host"
    }
  )
}

# Internet Gateway (create if it doesn't exist)
resource "aws_internet_gateway" "jumphost" {
  vpc_id = data.aws_vpc.existing.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.deployment_name}-jumphost-igw"
      ManagedBy = "Terraform"
    }
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.existing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jumphost.id
  }

  tags = merge(
    var.tags,
    {
      Name      = "${var.deployment_name}-jumphost-public-rt"
      ManagedBy = "Terraform"
    }
  )
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group for Windows jump host
resource "aws_security_group" "jump_host" {
  name_prefix = "${var.deployment_name}-jumphost-"
  description = "Security group for Windows jump host - allows RDP and management access to AVE/DDVE"
  vpc_id      = data.aws_vpc.existing.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.deployment_name}-jumphost-sg"
      ManagedBy = "Terraform"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# RDP access from specified CIDR (or current public IP)
resource "aws_security_group_rule" "jump_host_rdp" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [local.rdp_cidr]
  security_group_id = aws_security_group.jump_host.id
  description       = "RDP access from authorized IP"
}

# Avamar client inbound - AVE needs to connect TO the jump host for backups
# Port 28001: Avamar Administrator Server Port (client activation)
# Port 28002: Avamar avagent notification port (workorder notification from utility node)
resource "aws_security_group_rule" "jump_host_avamar_client" {
  count             = var.private_subnet_cidr != null ? 1 : 0
  type              = "ingress"
  from_port         = 28001
  to_port           = 28002
  protocol          = "tcp"
  cidr_blocks       = [var.private_subnet_cidr]
  security_group_id = aws_security_group.jump_host.id
  description       = "Avamar client agent (avagent) inbound from AVE"
}

# Allow all outbound traffic (for internet access, Windows updates, and AVE/DDVE management)
resource "aws_security_group_rule" "jump_host_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jump_host.id
  description       = "Allow all outbound traffic"
}

# Windows Server 2022 jump host
resource "aws_instance" "jump_host" {
  ami           = data.aws_ami.windows_2022.id
  instance_type = var.jump_host_instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_pair_name

  # Attach jump host security group + optional backup_internal_sg
  vpc_security_group_ids = concat(
    [aws_security_group.jump_host.id],
    var.backup_internal_sg_id != null ? [var.backup_internal_sg_id] : []
  )

  # Associate public IP
  associate_public_ip_address = true

  # Root block device
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    encrypted             = true
    delete_on_termination = true

    tags = merge(
      var.tags,
      {
        Name      = "${var.deployment_name}-jumphost-root"
        ManagedBy = "Terraform"
      }
    )
  }

  # Enable IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # User data to configure Windows
  user_data = <<-EOF
    <powershell>
    # Set timezone to UTC
    Set-TimeZone -Id "UTC"

    # Enable RDP
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

    # Set Windows Update to manual
    Set-Service -Name wuauserv -StartupType Manual

    # Install Chrome for web management access to DDVE/AVE
    $ChromeInstallerUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    $ChromeInstallerPath = "$env:TEMP\chrome_installer.exe"
    try {
      Invoke-WebRequest -Uri $ChromeInstallerUrl -OutFile $ChromeInstallerPath -UseBasicParsing
      Start-Process -FilePath $ChromeInstallerPath -Args "/silent /install" -Wait
      Remove-Item $ChromeInstallerPath -ErrorAction SilentlyContinue
    } catch {
      Write-Host "Chrome installation failed, but continuing..."
    }

    # Disable IE Enhanced Security Configuration for Administrators
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0

    # Create desktop shortcuts for AVE/DDVE (if IPs provided via tags)
    # Note: IPs should be added as tags when creating the instance
    </powershell>
  EOF

  tags = merge(
    var.tags,
    {
      Name      = "${var.deployment_name}-jumphost"
      ManagedBy = "Terraform"
      OS        = "Windows Server 2022"
      Purpose   = "Jump Host for AVE/DDVE Testing"
    }
  )
}

# Elastic IP for jump host (persistent IP across restarts)
resource "aws_eip" "jump_host" {
  domain   = "vpc"
  instance = aws_instance.jump_host.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.deployment_name}-jumphost-eip"
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.jumphost]
}
