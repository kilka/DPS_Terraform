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
  default     = "ave-sg-"
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for AVE instances with all required ports"
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to AVE instances"
  type        = list(string)
  default     = []
}

variable "allowed_management_cidr_blocks" {
  description = "CIDR blocks allowed to access AVE management interfaces (HTTPS:443, ports 161, 163, 700, 7543, 8543, 9090, 9443, 27000, 29000)"
  type        = list(string)
  default     = []
}

variable "allowed_data_cidr_blocks" {
  description = "CIDR blocks allowed to access AVE data/backup ports (7778-7781, 28001-28002, 28810-28819, 30001-30010)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the security group"
  type        = map(string)
  default     = {}
}
