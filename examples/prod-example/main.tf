# Example: Production deployment with AVE and DDVE
# This example uses existing VPC and networking infrastructure provided by cloud team
# No jump host, NAT gateway, or public IPs - production security model

# Reference existing VPC (provided by cloud team)
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Reference existing private subnet (provided by cloud team)
data "aws_subnet" "existing" {
  id = var.subnet_id
}

# Data source for current region
data "aws_region" "current" {}

# Optional: KMS key for EBS encryption
# Uncomment to use customer-managed KMS keys instead of AWS-managed encryption
# data "aws_kms_key" "ebs" {
#   key_id = var.kms_key_id
# }

# Security Group 1: Internal communication between backup devices (REQUIRED)
module "backup_internal_sg" {
  source = "../../modules/security-groups/backup-internal"

  vpc_id = data.aws_vpc.existing.id
  name   = "${var.deployment_name}-backup-internal-sg"

  tags = var.tags
}

# Security Group 2: Management and monitoring access (REQUIRED)
module "backup_management_sg" {
  source = "../../modules/security-groups/backup-management"

  vpc_id = data.aws_vpc.existing.id
  name   = "${var.deployment_name}-backup-management-sg"

  # Production management network CIDRs
  onprem_mgmt_cidr_blocks = var.onprem_mgmt_cidr_blocks
  dpa_server_cidr_blocks  = var.dpa_server_cidr_blocks
  ntp_server_ips          = var.ntp_server_ips
  dns_server_ips          = var.dns_server_ips
  smtp_server_ips         = var.smtp_server_ips
  dell_esrs_ips           = var.dell_esrs_ips

  tags = var.tags
}

# Security Group 3: On-premises backup connectivity (REQUIRED)
module "backup_onprem_sg" {
  source = "../../modules/security-groups/backup-onprem"

  vpc_id = data.aws_vpc.existing.id
  name   = "${var.deployment_name}-backup-onprem-sg"

  # Production on-premises backup infrastructure CIDRs
  onprem_backup_cidr_blocks = var.onprem_backup_cidr_blocks

  tags = var.tags
}

# AVE instance
module "ave" {
  source = "../../modules/ave"

  name_tag      = "${var.deployment_name}-ave-01"
  model         = var.ave_model
  ave_version   = var.ave_version
  vpc_id        = data.aws_vpc.existing.id
  subnet_id     = data.aws_subnet.existing.id
  key_pair_name = var.key_pair_name

  # Attach all three security groups
  security_group_ids = [
    module.backup_internal_sg.security_group_id,
    module.backup_management_sg.security_group_id,
    module.backup_onprem_sg.security_group_id
  ]

  # Optional: Specify KMS key for EBS encryption (uncomment to use)
  # kms_key_id = var.kms_key_id

  tags = var.tags
}

# DDVE instance
module "ddve" {
  source = "../../modules/ddve"

  name_tag         = "${var.deployment_name}-ddve-01"
  model            = var.ddve_model
  vpc_id           = data.aws_vpc.existing.id
  subnet_id        = data.aws_subnet.existing.id
  key_pair_name    = var.key_pair_name
  create_s3_bucket = true
  # S3 bucket name defaults to "${name_tag}-ddve-bucket" if not specified

  # Attach all three security groups
  security_group_ids = [
    module.backup_internal_sg.security_group_id,
    module.backup_management_sg.security_group_id,
    module.backup_onprem_sg.security_group_id
  ]

  # Optional: Specify KMS key for EBS encryption (uncomment to use)
  # kms_key_id = var.kms_key_id

  tags = var.tags
}
