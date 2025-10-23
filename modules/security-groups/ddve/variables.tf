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
  default     = "ddve-sg-"
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for DDVE instances with all required ports"
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to DDVE instances"
  type        = list(string)
  default     = []
}

variable "allowed_management_cidr_blocks" {
  description = "CIDR blocks allowed to access DDVE management interfaces (HTTPS:443, SMS:3009, SNMP)"
  type        = list(string)
  default     = []
}

variable "allowed_data_cidr_blocks" {
  description = "CIDR blocks allowed to access DDVE data ports (NFS:2049, Replication:2051-2052, RPC:111)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the security group"
  type        = map(string)
  default     = {}
}
