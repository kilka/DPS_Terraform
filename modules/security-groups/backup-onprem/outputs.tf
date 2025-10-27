output "security_group_id" {
  description = "ID of the backup on-prem security group"
  value       = aws_security_group.backup_onprem.id
}

output "security_group_arn" {
  description = "ARN of the backup on-prem security group"
  value       = aws_security_group.backup_onprem.arn
}

output "security_group_name" {
  description = "Name of the backup on-prem security group"
  value       = aws_security_group.backup_onprem.name
}
