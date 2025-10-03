variable "name_tag" {
  description = "Name tag for the DDVE EC2 instance and EBS volumes"
  type        = string
}

variable "model" {
  description = "DDVE model selection (determines instance type and disk configuration)"
  type        = string
  default     = "16TB"
  validation {
    condition     = contains(["16TB", "32TB", "96TB", "256TB"], var.model)
    error_message = "Model must be one of: 16TB, 32TB, 96TB, 256TB"
  }
}

variable "metadata_disk_count" {
  description = "Number of metadata disks to attach (1-24). If null, uses default for the model."
  type        = number
  default     = null
  validation {
    condition     = var.metadata_disk_count == null || (var.metadata_disk_count >= 1 && var.metadata_disk_count <= 24)
    error_message = "Metadata disk count must be between 1 and 24, or null for default"
  }
}

variable "iam_role_name" {
  description = "Name of existing IAM role to attach to the instance. If not provided, a new role will be created."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "Name of S3 bucket for DDVE storage. If create_s3_bucket is true, this bucket will be created. Otherwise, it should reference an existing bucket."
  type        = string
}

variable "create_s3_bucket" {
  description = "Whether to create a new S3 bucket for DDVE storage"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID where DDVE will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where DDVE instance will be deployed"
  type        = string
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the DDVE instance (beyond the DDVE-specific security group created by this module)"
  type        = list(string)
  default     = []
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH access to the DDVE instance"
  type        = string
}

variable "aws_partition" {
  description = "AWS partition for IAM role ARNs (aws, aws-us-gov, or aws-iso)"
  type        = string
  default     = "aws"
  validation {
    condition     = contains(["aws", "aws-us-gov", "aws-iso"], var.aws_partition)
    error_message = "AWS partition must be one of: aws, aws-us-gov, aws-iso"
  }
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to the DDVE instance"
  type        = list(string)
  default     = []
}

variable "allowed_management_cidr_blocks" {
  description = "CIDR blocks allowed to access DDVE management interfaces (HTTPS:443, SMS:3009)"
  type        = list(string)
  default     = []
}

variable "allowed_data_cidr_blocks" {
  description = "CIDR blocks allowed to access DDVE data ports (NFS:2049, Replication:2051)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
