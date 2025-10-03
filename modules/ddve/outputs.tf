output "instance_id" {
  description = "ID of the DDVE EC2 instance"
  value       = aws_instance.ddve.id
}

output "instance_arn" {
  description = "ARN of the DDVE EC2 instance"
  value       = aws_instance.ddve.arn
}

output "private_ip" {
  description = "Private IP address of the DDVE instance"
  value       = aws_instance.ddve.private_ip
}

output "availability_zone" {
  description = "Availability zone where the DDVE instance is deployed"
  value       = aws_instance.ddve.availability_zone
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket used for DDVE storage"
  value       = var.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket (if created by this module)"
  value       = var.create_s3_bucket ? aws_s3_bucket.ddve[0].arn : null
}

output "security_group_id" {
  description = "ID of the DDVE-specific security group"
  value       = aws_security_group.ddve.id
}

output "iam_role_name" {
  description = "Name of the IAM role attached to the DDVE instance"
  value       = local.create_iam_role ? aws_iam_role.ddve[0].name : var.iam_role_name
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the DDVE instance"
  value       = local.create_iam_role ? aws_iam_role.ddve[0].arn : data.aws_iam_role.existing[0].arn
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = local.create_iam_role ? aws_iam_instance_profile.ddve[0].name : var.iam_role_name
}

output "nvram_volume_id" {
  description = "ID of the NVRAM EBS volume"
  value       = aws_ebs_volume.nvram.id
}

output "metadata_volume_ids" {
  description = "IDs of the metadata EBS volumes"
  value       = aws_ebs_volume.metadata[*].id
}

output "model" {
  description = "DDVE model deployed"
  value       = var.model
}

output "instance_type" {
  description = "EC2 instance type used"
  value       = local.selected_config.instance_type
}

output "metadata_disk_count" {
  description = "Number of metadata disks attached"
  value       = local.metadata_disk_count
}
