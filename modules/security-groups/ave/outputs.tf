output "security_group_id" {
  description = "ID of the AVE security group"
  value       = aws_security_group.ave.id
}

output "security_group_arn" {
  description = "ARN of the AVE security group"
  value       = aws_security_group.ave.arn
}

output "security_group_name" {
  description = "Name of the AVE security group"
  value       = aws_security_group.ave.name
}
