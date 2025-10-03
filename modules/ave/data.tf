data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Lookup the AVE AMI using name pattern
# Note: include_deprecated = true is required to find AVE AMIs
data "aws_ami" "ave" {
  most_recent        = true
  include_deprecated = true
  owners             = ["679593333241"] # Dell AVE AMI owner

  filter {
    name   = "name"
    values = ["DELL_Avamar_Virtual_Edition_${var.ave_version}*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get subnet details for availability zone
data "aws_subnet" "selected" {
  id = var.subnet_id
}
