output "security_group_id" {
  description = "ID of the backup security group"
  value       = aws_security_group.backup.id
}

output "security_group_arn" {
  description = "ARN of the backup security group"
  value       = aws_security_group.backup.arn
}

output "security_group_name" {
  description = "Name of the backup security group"
  value       = aws_security_group.backup.name
}
