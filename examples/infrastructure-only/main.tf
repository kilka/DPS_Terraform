# Example: Deploy infrastructure only (VPC, subnets, jump host)
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
