# Example: Deploy infrastructure only (VPC, subnets, jump host, and security groups)
# Use this for testing CloudFormation templates in the AWS Console

module "lab" {
  source = "../../modules/lab"

  lab_name                = var.lab_name
  jump_host_key_pair_name = var.key_pair_name

  # Disable NAT Gateway - not needed for CloudFormation testing
  enable_nat_gateway = false

  tags = {
    Environment = "Lab"
    Project     = "CloudFormation-Testing"
    Owner       = var.owner_tag
  }
}

# Create AVE security group for CloudFormation template use
module "ave_security_group" {
  source = "../../modules/security-groups/ave"

  vpc_id      = module.lab.vpc_id
  name        = "${var.lab_name}-ave-sg"
  name_prefix = "${var.lab_name}-ave-"

  # Allow SSH and management access from entire VPC
  allowed_ssh_cidr_blocks        = [module.lab.vpc_cidr]
  allowed_management_cidr_blocks = [module.lab.vpc_cidr]
  # Allow data/backup traffic from VPC
  allowed_data_cidr_blocks = [module.lab.vpc_cidr]

  tags = {
    Environment = "Lab"
    Project     = "CloudFormation-Testing"
    Owner       = var.owner_tag
  }
}

# Create DDVE security group for CloudFormation template use
module "ddve_security_group" {
  source = "../../modules/security-groups/ddve"

  vpc_id      = module.lab.vpc_id
  name        = "${var.lab_name}-ddve-sg"
  name_prefix = "${var.lab_name}-ddve-"

  # Allow SSH and management access from entire VPC
  allowed_ssh_cidr_blocks        = [module.lab.vpc_cidr]
  allowed_management_cidr_blocks = [module.lab.vpc_cidr]
  # Allow data traffic from VPC
  allowed_data_cidr_blocks = [module.lab.vpc_cidr]

  tags = {
    Environment = "Lab"
    Project     = "CloudFormation-Testing"
    Owner       = var.owner_tag
  }
}
