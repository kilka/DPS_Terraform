variable "deployment_name" {
  description = "Name prefix for all jump host resources"
  type        = string
  default     = "prod-backup-test"
}

variable "vpc_id" {
  description = "ID of existing VPC (from prod-example). Get this from prod-example outputs: terraform output -raw vpc_id"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the new public subnet (for jump host)"
  type        = string
  default     = "10.0.99.0/24"
  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR block"
  }
}

variable "private_subnet_cidr" {
  description = "Optional: CIDR block of the private subnet where AVE/DDVE are deployed. If provided, allows Avamar client inbound traffic from AVE."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability zone for the public subnet (if not specified, uses first AZ in region)"
  type        = string
  default     = null
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair to use for the Windows jump host (required to decrypt Administrator password)"
  type        = string
}

variable "jump_host_instance_type" {
  description = "Instance type for Windows jump host"
  type        = string
  default     = "t3.medium"
}

variable "allowed_rdp_cidr" {
  description = "CIDR block allowed to RDP to jump host. If null, auto-detects and uses your current public IP/32"
  type        = string
  default     = null
}

variable "backup_internal_sg_id" {
  description = "Optional: Security group ID from prod-example backup_internal module. If provided, attaches to jump host to enable backup protocol testing. Get from prod-example outputs: terraform output -raw backup_internal_sg_id"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Testing"
    Project     = "Backup Infrastructure"
    Purpose     = "Jump Host"
  }
}
