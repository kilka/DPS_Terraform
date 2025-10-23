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

variable "security_group_ids" {
  description = "List of security group IDs to attach to the AVE instance. Use the security-groups/ave module to create an AVE-specific security group."
  type        = list(string)
  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group ID must be provided. Use the modules/security-groups/ave module to create an AVE security group."
  }
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH access to the AVE instance"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
