# VPC and Network Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = data.aws_vpc.existing.id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = data.aws_subnet.existing.id
}

output "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  value       = data.aws_subnet.existing.cidr_block
}

# Security Group Outputs (for jumphost example)
output "backup_internal_sg_id" {
  description = "Security group ID for backup internal communication (for jumphost example)"
  value       = module.backup_internal_sg.security_group_id
}

output "backup_management_sg_id" {
  description = "Security group ID for backup management (for jumphost example)"
  value       = module.backup_management_sg.security_group_id
}

output "backup_onprem_sg_id" {
  description = "Security group ID for on-premises backup connectivity (for jumphost example)"
  value       = module.backup_onprem_sg.security_group_id
}

# AVE Outputs
output "ave_instance_id" {
  description = "AVE instance ID"
  value       = module.ave.instance_id
}

output "ave_private_ip" {
  description = "AVE private IP address"
  value       = module.ave.private_ip
}

output "ave_management_url" {
  description = "AVE management URL"
  value       = "https://${module.ave.private_ip}:8543"
}

# DDVE Outputs
output "ddve_instance_id" {
  description = "DDVE instance ID"
  value       = module.ddve.instance_id
}

output "ddve_private_ip" {
  description = "DDVE private IP address"
  value       = module.ddve.private_ip
}

output "ddve_management_url" {
  description = "DDVE management URL"
  value       = "https://${module.ddve.private_ip}"
}

output "s3_bucket_name" {
  description = "S3 bucket name for DDVE storage"
  value       = module.ddve.s3_bucket_name
}

# Quick Reference
output "deployment_info" {
  description = "Production deployment information"
  value       = <<-EOT

  ========================================
  Production AVE and DDVE Deployment
  ========================================

  AVE (${var.ave_model}):
    Instance ID: ${module.ave.instance_id}
    Private IP:  ${module.ave.private_ip}
    Management:  https://${module.ave.private_ip}:8543
    SSH:         ssh admin@${module.ave.private_ip}

  DDVE (${var.ddve_model}):
    Instance ID: ${module.ddve.instance_id}
    Private IP:  ${module.ddve.private_ip}
    Management:  https://${module.ddve.private_ip}
    SSH:         ssh sysadmin@${module.ddve.private_ip}
    S3 Bucket:   ${module.ddve.s3_bucket_name}

  Network:
    VPC ID:      ${data.aws_vpc.existing.id}
    Subnet ID:   ${data.aws_subnet.existing.id}
    Subnet CIDR: ${data.aws_subnet.existing.cidr_block}

  Security Groups:
    Internal:    ${module.backup_internal_sg.security_group_id}
    Management:  ${module.backup_management_sg.security_group_id}
    On-Premises: ${module.backup_onprem_sg.security_group_id}

  Note: All instances are in private subnet with no public IPs.
  Access via VPN, Direct Connect, or bastion host required.

  To deploy a jump host for testing, see: examples/jumphost/

  ========================================
  EOT
}
