output "security_group_id" {
  description = "ID of the backup management security group"
  value       = aws_security_group.backup_management.id
}

output "security_group_arn" {
  description = "ARN of the backup management security group"
  value       = aws_security_group.backup_management.arn
}

output "security_group_name" {
  description = "Name of the backup management security group"
  value       = aws_security_group.backup_management.name
}
