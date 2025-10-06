# Example: Deploy lab environment with AVE and DDVE instances

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

  # Security: No additional security groups needed - AVE module creates its own
  additional_security_group_ids = []

  # Allow SSH and management access from entire VPC (jump host can access)
  allowed_ssh_cidr_blocks        = [module.lab.vpc_cidr]
  allowed_management_cidr_blocks = [module.lab.vpc_cidr]
  # Allow data/backup traffic from VPC (for DDVE integration)
  allowed_data_cidr_blocks = [module.lab.vpc_cidr]

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

  # Security: No additional security groups needed - AVE module creates its own
  additional_security_group_ids = []

  # Allow SSH and management access from entire VPC (jump host can access)
  allowed_ssh_cidr_blocks        = [module.lab.vpc_cidr]
  allowed_management_cidr_blocks = [module.lab.vpc_cidr]
  # Allow data traffic from VPC (for AVE integration)
  allowed_data_cidr_blocks = [module.lab.vpc_cidr]

  tags = {
    Environment = "Lab"
    Project     = "AVE-DDVE-Testing"
    Owner       = var.owner_tag
  }
}
