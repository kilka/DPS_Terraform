# Jump Host Connection Information
output "jump_host_public_ip" {
  description = "Public IP address of the jump host (use this for RDP)"
  value       = aws_eip.jump_host.public_ip
}

output "jump_host_private_ip" {
  description = "Private IP address of the jump host"
  value       = aws_instance.jump_host.private_ip
}

output "jump_host_instance_id" {
  description = "EC2 instance ID of the jump host"
  value       = aws_instance.jump_host.id
}

# RDP Connection Instructions
output "rdp_connection_info" {
  description = "Instructions for RDP connection"
  value = <<-EOT
    RDP Connection:
      Host: ${aws_eip.jump_host.public_ip}
      Port: 3389
      Username: Administrator
      Password: Use the command below to decrypt the password

    To get the Administrator password, run:
      aws ec2 get-password-data --instance-id ${aws_instance.jump_host.id} --priv-launch-key /path/to/${var.key_pair_name}.pem --query 'PasswordData' --output text

    Alternative (if using AWS CLI v2):
      aws ec2 get-password-data --instance-id ${aws_instance.jump_host.id} --priv-launch-key /path/to/${var.key_pair_name}.pem | jq -r .PasswordData

    Note: It may take 5-10 minutes after instance launch for the password to be available.
  EOT
}

output "password_decrypt_command" {
  description = "AWS CLI command to decrypt the Windows Administrator password"
  value       = "aws ec2 get-password-data --instance-id ${aws_instance.jump_host.id} --priv-launch-key /path/to/${var.key_pair_name}.pem --query 'PasswordData' --output text"
}

# Network Information
output "public_subnet_id" {
  description = "ID of the public subnet created for the jump host"
  value       = aws_subnet.public.id
}

output "public_subnet_cidr" {
  description = "CIDR block of the public subnet"
  value       = aws_subnet.public.cidr_block
}

output "jump_host_security_group_id" {
  description = "Security group ID of the jump host"
  value       = aws_security_group.jump_host.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.jumphost.id
}

# Usage Instructions
output "usage_instructions" {
  description = "Quick start instructions for using the jump host"
  value = <<-EOT
    Jump Host Deployed Successfully!

    1. Get Administrator Password:
       Run: aws ec2 get-password-data --instance-id ${aws_instance.jump_host.id} --priv-launch-key /path/to/${var.key_pair_name}.pem --query 'PasswordData' --output text

    2. Connect via RDP:
       Host: ${aws_eip.jump_host.public_ip}
       Username: Administrator
       Password: (from step 1)

    3. Access AVE/DDVE from Jump Host:
       - Get private IPs from prod-example outputs
       - Open Chrome on jump host
       - Navigate to:
         * AVE:  https://<ave-private-ip>:443
         * DDVE: https://<ddve-private-ip>:3009

    4. Cleanup:
       terraform destroy

    Note: Jump host has Chrome pre-installed for web management access.
  EOT
}
