variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "name" {
  description = "Name tag for the security group"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for the security group"
  type        = string
  default     = "backup-internal-sg-"
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for internal backup device communication (AVE/DDVE self-referencing rules)"
}

variable "tags" {
  description = "Additional tags to apply to the security group"
  type        = map(string)
  default     = {}
}
