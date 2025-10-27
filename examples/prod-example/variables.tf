variable "deployment_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "prod-backup"
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID of existing VPC (provided by cloud team)"
  type        = string
}

variable "subnet_id" {
  description = "ID of existing private subnet (provided by cloud team)"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair to use for AVE and DDVE"
  type        = string
}

variable "ave_model" {
  description = "AVE model to deploy (0.5TB, 1TB, 2TB, 4TB, 8TB, or 16TB)"
  type        = string
  default     = "2TB"
}

variable "ave_version" {
  description = "AVE version for AMI lookup (e.g., 19.9.0.0)"
  type        = string
  default     = "19.9.0.0"
}

variable "ddve_model" {
  description = "DDVE model to deploy (16TB, 32TB, 96TB, or 256TB)"
  type        = string
  default     = "256TB"
}

variable "onprem_mgmt_cidr_blocks" {
  description = "CIDR blocks for on-premises management networks"
  type        = list(string)
}

variable "dpa_server_cidr_blocks" {
  description = "CIDR blocks for DPA servers"
  type        = list(string)
  default     = []
}

variable "ntp_server_ips" {
  description = "IP addresses of NTP servers"
  type        = list(string)
  default     = []
}

variable "dns_server_ips" {
  description = "IP addresses of DNS servers"
  type        = list(string)
  default     = []
}

variable "smtp_server_ips" {
  description = "IP addresses of SMTP servers"
  type        = list(string)
  default     = []
}

variable "dell_esrs_ips" {
  description = "IP addresses of Dell ESRS servers"
  type        = list(string)
  default     = []
}

variable "onprem_backup_cidr_blocks" {
  description = "CIDR blocks for on-premises backup infrastructure (Data Domain, Avamar)"
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "Optional: ARN of the KMS key for EBS encryption. If not specified, uses AWS-managed encryption keys."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "Backup Infrastructure"
  }
}
