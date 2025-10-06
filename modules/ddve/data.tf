data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Lookup the DDVE AMI for the current region
data "aws_ami" "ddve" {
  most_recent = false
  owners      = ["679593333241"] # Dell DDVE AMI owner

  filter {
    name   = "image-id"
    values = [local.ami_ids[data.aws_region.current.id]]
  }
}

# Get subnet details for availability zone
data "aws_subnet" "selected" {
  id = var.subnet_id
}
