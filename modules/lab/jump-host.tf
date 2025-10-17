# Windows Server 2022 jump host
resource "aws_instance" "jump_host" {
  ami           = data.aws_ami.windows_2022.id
  instance_type = var.jump_host_instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = var.jump_host_key_pair_name

  vpc_security_group_ids = [
    aws_security_group.jump_host.id
  ]

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
        Name      = "${var.lab_name}-jump-host-root"
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

  # User data to set administrator password and enable RDP
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
    Invoke-WebRequest -Uri $ChromeInstallerUrl -OutFile $ChromeInstallerPath
    Start-Process -FilePath $ChromeInstallerPath -Args "/silent /install" -Wait
    Remove-Item $ChromeInstallerPath
    </powershell>
  EOF

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-jump-host"
      ManagedBy = "Terraform"
      OS        = "Windows Server 2022"
    }
  )
}

# Elastic IP for jump host (optional, for persistent IP)
resource "aws_eip" "jump_host" {
  domain   = "vpc"
  instance = aws_instance.jump_host.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-jump-host-eip"
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.lab]
}
