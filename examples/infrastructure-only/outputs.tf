# Infrastructure outputs for CloudFormation template deployment

output "vpc_id" {
  description = "VPC ID - Use this in CloudFormation templates"
  value       = module.lab.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID - Use for resources that need internet access"
  value       = module.lab.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID - Use for AVE/DDVE instances"
  value       = module.lab.private_subnet_id
}

output "private_route_table_id" {
  description = "Private route table ID - S3 VPC endpoint is attached here"
  value       = module.lab.private_route_table_id
}

output "s3_vpc_endpoint_id" {
  description = "S3 VPC Gateway Endpoint ID - Required for DDVE S3 access"
  value       = module.lab.s3_vpc_endpoint_id
}

output "jump_host_public_ip" {
  description = "Jump host public IP - Use this to RDP"
  value       = module.lab.jump_host_public_ip
}

output "jump_host_private_ip" {
  description = "Jump host private IP"
  value       = module.lab.jump_host_private_ip
}

output "rdp_connection_string" {
  description = "RDP connection command"
  value       = module.lab.rdp_connection_string
}

output "jump_host_password_command" {
  description = "Command to retrieve Windows administrator password"
  value       = module.lab.jump_host_password_command
}

# S3 Bucket outputs
output "s3_bucket_name" {
  description = "S3 bucket name for DDVE"
  value       = aws_s3_bucket.ddve.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.ddve.arn
}

# IAM Role outputs
output "ddve_iam_role_name" {
  description = "IAM role name for DDVE"
  value       = aws_iam_role.ddve.name
}

output "ddve_iam_role_arn" {
  description = "IAM role ARN for DDVE"
  value       = aws_iam_role.ddve.arn
}

output "ddve_instance_profile_name" {
  description = "IAM instance profile name for DDVE"
  value       = aws_iam_instance_profile.ddve.name
}

output "ddve_instance_profile_arn" {
  description = "IAM instance profile ARN for DDVE"
  value       = aws_iam_instance_profile.ddve.arn
}

# Helpful information for CloudFormation deployments
output "cloudformation_parameters" {
  description = "Use these values when deploying CloudFormation templates"
  value = {
    VpcId                 = module.lab.vpc_id
    SubnetId              = module.lab.private_subnet_id
    PublicSubnetId        = module.lab.public_subnet_id
    S3EndpointId          = module.lab.s3_vpc_endpoint_id
    JumpHostPrivateIP     = module.lab.jump_host_private_ip
    AllowedCIDR           = module.lab.vpc_cidr
    S3BucketName          = aws_s3_bucket.ddve.id
    DdveIamRoleName       = aws_iam_role.ddve.name
    DdveInstanceProfile   = aws_iam_instance_profile.ddve.name
  }
}
