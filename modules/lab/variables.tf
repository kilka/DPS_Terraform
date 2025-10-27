variable "lab_name" {
  description = "Name prefix for all lab resources"
  type        = string
  default     = "dps-lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet (jump host)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet (DDVE/AVE)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnets (if not specified, uses first AZ in region)"
  type        = string
  default     = null
}

variable "jump_host_instance_type" {
  description = "Instance type for Windows jump host"
  type        = string
  default     = "t3.medium"
}

variable "jump_host_key_pair_name" {
  description = "EC2 key pair name for the Windows jump host"
  type        = string
}

variable "allowed_rdp_cidr" {
  description = "CIDR block allowed to RDP to jump host. If null, uses current public IP"
  type        = string
  default     = null
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnet internet access"
  type        = bool
  default     = false
}

variable "additional_jump_host_security_group_ids" {
  description = "Additional security group IDs to attach to the jump host (e.g., backup-internal for testing)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
