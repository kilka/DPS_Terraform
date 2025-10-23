output "security_group_id" {
  description = "ID of the DDVE security group"
  value       = aws_security_group.ddve.id
}

output "security_group_arn" {
  description = "ARN of the DDVE security group"
  value       = aws_security_group.ddve.arn
}

output "security_group_name" {
  description = "Name of the DDVE security group"
  value       = aws_security_group.ddve.name
}
