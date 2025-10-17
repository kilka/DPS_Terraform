data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
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
