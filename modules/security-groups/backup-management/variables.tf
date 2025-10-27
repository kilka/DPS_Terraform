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
  default     = "Security group for backup infrastructure management, monitoring, and external services"
}

variable "onprem_mgmt_cidr_blocks" {
  description = "CIDR blocks for on-premises management hosts. Used for administrative access and management operations."
  type        = list(string)
  default     = []
}

variable "dpa_server_cidr_blocks" {
  description = "CIDR blocks for DPA (Data Protection Advisor) servers/agents. Used for monitoring and data collection."
  type        = list(string)
  default     = []
}

variable "ntp_server_ips" {
  description = "List of NTP server IP addresses for time synchronization"
  type        = list(string)
  default     = []
}

variable "dns_server_ips" {
  description = "List of DNS server IP addresses for name resolution"
  type        = list(string)
  default     = []
}

variable "smtp_server_ips" {
  description = "List of SMTP server IP addresses for email notifications"
  type        = list(string)
  default     = []
}

variable "dell_esrs_ips" {
  description = "List of Dell ESRS (Secure Remote Services) IP addresses for support connectivity"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the security group"
  type        = map(string)
  default     = {}
}
