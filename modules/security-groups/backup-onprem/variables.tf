variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "name" {
  description = "Name for the security group"
  type        = string
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for on-premises backup infrastructure connectivity (DD/Avamar replication)"
}

variable "onprem_backup_cidr_blocks" {
  description = "CIDR blocks for on-premises backup infrastructure (DD/Avamar). Bidirectional communication for backup operations."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the security group"
  type        = map(string)
  default     = {}
}
