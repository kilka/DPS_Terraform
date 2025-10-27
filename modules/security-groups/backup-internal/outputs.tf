output "security_group_id" {
  description = "ID of the backup internal security group"
  value       = aws_security_group.backup_internal.id
}

output "security_group_arn" {
  description = "ARN of the backup internal security group"
  value       = aws_security_group.backup_internal.arn
}

output "security_group_name" {
  description = "Name of the backup internal security group"
  value       = aws_security_group.backup_internal.name
}
