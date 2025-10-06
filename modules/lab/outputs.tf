output "vpc_id" {
  description = "ID of the lab VPC"
  value       = aws_vpc.lab.id
}

output "vpc_cidr" {
  description = "CIDR block of the lab VPC"
  value       = aws_vpc.lab.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet (for jump host)"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet (for DDVE/AVE)"
  value       = aws_subnet.private.id
}

output "private_route_table_id" {
  description = "ID of the private route table (for S3 VPC endpoint)"
  value       = aws_route_table.private.id
}

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC Gateway Endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "jump_host_id" {
  description = "ID of the Windows jump host instance"
  value       = aws_instance.jump_host.id
}

output "jump_host_public_ip" {
  description = "Public IP address of the Windows jump host (Elastic IP)"
  value       = aws_eip.jump_host.public_ip
}

output "jump_host_private_ip" {
  description = "Private IP address of the Windows jump host"
  value       = aws_instance.jump_host.private_ip
}

output "jump_host_security_group_id" {
  description = "ID of the jump host security group"
  value       = aws_security_group.jump_host.id
}

# jump_to_backup security group removed - see security-groups.tf for explanation

output "public_subnet_cidr" {
  description = "CIDR block of the public subnet (for configuring AVE/DDVE ingress)"
  value       = aws_subnet.public.cidr_block
}

output "private_subnet_cidr" {
  description = "CIDR block of the private subnet (for configuring AVE/DDVE communication)"
  value       = aws_subnet.private.cidr_block
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (if enabled)"
  value       = var.enable_nat_gateway ? aws_nat_gateway.lab[0].id : null
}

output "allowed_rdp_cidr" {
  description = "CIDR block allowed for RDP access"
  value       = local.rdp_cidr
}

output "rdp_connection_string" {
  description = "RDP connection string for jump host"
  value       = "mstsc /v:${aws_eip.jump_host.public_ip}"
}

output "jump_host_password_command" {
  description = "AWS CLI command to retrieve Windows administrator password"
  value       = "aws ec2 get-password-data --instance-id ${aws_instance.jump_host.id} --priv-launch-key /path/to/your/private-key.pem"
}
