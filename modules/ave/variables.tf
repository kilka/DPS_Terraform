variable "name_tag" {
  description = "Name tag for the AVE EC2 instance and EBS volumes"
  type        = string
}

variable "model" {
  description = "AVE model selection (determines instance type and disk configuration)"
  type        = string
  default     = "2TB"
  validation {
    condition     = contains(["0.5TB", "1TB", "2TB", "4TB", "8TB", "16TB"], var.model)
    error_message = "Model must be one of: 0.5TB, 1TB, 2TB, 4TB, 8TB, 16TB"
  }
}

variable "ave_version" {
  description = "AVE version for AMI lookup (e.g., 19.9.0.0)"
  type        = string
  default     = "19.9.0.0"
}

variable "vpc_id" {
  description = "VPC ID where AVE will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where AVE instance will be deployed"
  type        = string
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the AVE instance (beyond the AVE-specific security group created by this module)"
  type        = list(string)
  default     = []
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH access to the AVE instance"
  type        = string
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to the AVE instance"
  type        = list(string)
  default     = []
}

variable "allowed_management_cidr_blocks" {
  description = "CIDR blocks allowed to access AVE management interfaces (HTTPS:443, ports 161, 163, 700, 7543, 8543, 9090, 9443, 27000, 29000)"
  type        = list(string)
  default     = []
}

variable "allowed_data_cidr_blocks" {
  description = "CIDR blocks allowed to access AVE data/backup ports (7778-7781, 28001-28002, 28810-28819, 30001-30003)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
