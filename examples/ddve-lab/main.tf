# Example: Deploy lab environment with shared security groups and AVE/DDVE instances

# Lab infrastructure
module "lab" {
  source = "../../modules/lab"

  lab_name                = "ave-ddve-lab"
  jump_host_key_pair_name = var.key_pair_name

  # Optional: customize VPC settings
  # vpc_cidr            = "10.0.0.0/16"
  # public_subnet_cidr  = "10.0.1.0/24"
  # private_subnet_cidr = "10.0.2.0/24"

  # Disable NAT Gateway - not needed (DDVE uses S3 VPC endpoint, jump host has direct internet)
  enable_nat_gateway = false

  # Attach backup-internal SG to jump host for testing (allows jump host to use backup protocols)
  additional_jump_host_security_group_ids = [module.backup_internal_sg.security_group_id]

  tags = {
    Environment = "Lab"
    Project     = "AVE-DDVE-Testing"
    Owner       = var.owner_tag
  }
}

# Security Group 1: Internal communication between backup devices (REQUIRED)
module "backup_internal_sg" {
  source = "../../modules/security-groups/backup-internal"

  vpc_id      = module.lab.vpc_id
  name        = "lab-backup-internal-sg"
  name_prefix = "lab-internal-"

  tags = {
    Environment = "Lab"
    Project     = "AVE-DDVE-Testing"
    Owner       = var.owner_tag
  }
}

# Security Group 2: Management and monitoring access (REQUIRED)
module "backup_management_sg" {
  source = "../../modules/security-groups/backup-management"

  vpc_id      = module.lab.vpc_id
  name        = "lab-backup-management-sg"
  name_prefix = "lab-mgmt-"

  # Use jump host subnet for management access
  onprem_mgmt_cidr_blocks = [module.lab.public_subnet_cidr] # Jump host subnet
  dpa_server_cidr_blocks  = ["10.2.0.0/24"]                 # Simulated DPA servers
  ntp_server_ips          = ["10.3.0.1"]                    # Simulated NTP server
  dns_server_ips          = ["10.4.0.1"]                    # Simulated DNS server
  smtp_server_ips         = ["10.5.0.1"]                    # Simulated SMTP server
  dell_esrs_ips           = ["10.6.0.1"]                    # Simulated Dell ESRS

  tags = {
    Environment = "Lab"
    Project     = "AVE-DDVE-Testing"
    Owner       = var.owner_tag
  }
}

# Security Group 3: On-premises backup connectivity (OPTIONAL - for testing)
module "backup_onprem_sg" {
  source = "../../modules/security-groups/backup-onprem"

  vpc_id      = module.lab.vpc_id
  name        = "lab-backup-onprem-sg"
  name_prefix = "lab-onprem-"

  # Dummy values for lab testing - simulating on-prem backup infrastructure
  onprem_backup_cidr_blocks = ["10.0.0.0/24"] # Simulated on-prem DD/Avamar

  tags = {
    Environment = "Lab"
    Project     = "AVE-DDVE-Testing"
    Owner       = var.owner_tag
  }
}

# AVE instance
module "ave" {
  source = "../../modules/ave"

  name_tag      = "lab-ave-01"
  model         = var.ave_model
  ave_version   = var.ave_version
  vpc_id        = module.lab.vpc_id
  subnet_id     = module.lab.private_subnet_id
  key_pair_name = var.key_pair_name

  # Attach all three security groups (internal + management + onprem)
  security_group_ids = [
    module.backup_internal_sg.security_group_id,
    module.backup_management_sg.security_group_id,
    module.backup_onprem_sg.security_group_id
  ]

  tags = {
    Environment = "Lab"
    Project     = "AVE-DDVE-Testing"
    Owner       = var.owner_tag
  }
}

# DDVE instance
module "ddve" {
  source = "../../modules/ddve"

  name_tag         = "lab-ddve-01"
  model            = var.ddve_model
  vpc_id           = module.lab.vpc_id
  subnet_id        = module.lab.private_subnet_id
  key_pair_name    = var.key_pair_name
  s3_bucket_name   = var.s3_bucket_name
  create_s3_bucket = true

  # Lab environment: allow force deletion of S3 bucket for clean teardown
  s3_force_destroy = true

  # Attach all three security groups (internal + management + onprem)
  security_group_ids = [
    module.backup_internal_sg.security_group_id,
    module.backup_management_sg.security_group_id,
    module.backup_onprem_sg.security_group_id
  ]

  tags = {
    Environment = "Lab"
    Project     = "AVE-DDVE-Testing"
    Owner       = var.owner_tag
  }
}
