# Lab Infrastructure Outputs
output "vpc_id" {
  description = "Lab VPC ID"
  value       = module.lab.vpc_id
}

output "jump_host_public_ip" {
  description = "Jump host public IP address"
  value       = module.lab.jump_host_public_ip
}

output "rdp_connection" {
  description = "RDP connection command"
  value       = module.lab.rdp_connection_string
}

output "jump_host_password_command" {
  description = "Command to retrieve Windows password"
  value       = module.lab.jump_host_password_command
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
  description = "AVE management URL (access from jump host)"
  value       = "https://${module.ave.private_ip}:8543"
}

output "ave_ssh_command" {
  description = "SSH command to access AVE (from jump host)"
  value       = "ssh -i /path/to/key.pem admin@${module.ave.private_ip}"
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
  description = "DDVE management URL (access from jump host)"
  value       = "https://${module.ddve.private_ip}"
}

output "s3_bucket_name" {
  description = "S3 bucket name for DDVE storage"
  value       = module.ddve.s3_bucket_name
}

output "ddve_ssh_command" {
  description = "SSH command to access DDVE (from jump host)"
  value       = "ssh -i /path/to/key.pem sysadmin@${module.ddve.private_ip}"
}

# Quick Start Guide
output "quick_start_guide" {
  description = "Quick start instructions"
  value       = <<-EOT

  ========================================
  AVE and DDVE Lab Environment - Quick Start
  ========================================

  1. GET WINDOWS PASSWORD:
     ${module.lab.jump_host_password_command}

  2. CONNECT TO JUMP HOST:
     ${module.lab.rdp_connection_string}
     Username: Administrator
     Password: <from step 1>

  3. ACCESS AVE FROM JUMP HOST:
     Management UI: https://${module.ave.private_ip}:8543
     SSH: ssh admin@${module.ave.private_ip}
     Instance ID: ${module.ave.instance_id}
     Model: ${var.ave_model}

  4. ACCESS DDVE FROM JUMP HOST:
     Management UI: https://${module.ddve.private_ip}
     SSH: ssh sysadmin@${module.ddve.private_ip}
     Instance ID: ${module.ddve.instance_id}
     Model: ${var.ddve_model}
     S3 Bucket: ${module.ddve.s3_bucket_name}

  5. CONFIGURE AVE-DDVE INTEGRATION:
     - AVE can connect to DDVE at: ${module.ddve.private_ip}
     - DDVE can accept backups from AVE at: ${module.ave.private_ip}
     - Both instances are in the same VPC with proper security groups

  6. CLEANUP WHEN DONE:
     terraform destroy

  ========================================
  EOT
}
