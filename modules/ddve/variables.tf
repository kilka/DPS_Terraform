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

variable "iam_instance_profile_name" {
  description = "Name of existing IAM instance profile to attach to the instance. If not provided, a new IAM role and instance profile will be created. Note: This must be an instance profile name, not an IAM role name."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "Name of S3 bucket for DDVE storage. If not provided, auto-generates as '{name_tag}-ddve-bucket'. If create_s3_bucket is true, this bucket will be created. Otherwise, it should reference an existing bucket."
  type        = string
  default     = null
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

variable "security_group_ids" {
  description = "List of security group IDs to attach to the DDVE instance. Use the security-groups/ddve module to create a DDVE-specific security group."
  type        = list(string)
  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group ID must be provided. Use the modules/security-groups/ddve module to create a DDVE security group."
  }
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

variable "s3_force_destroy" {
  description = "When true, allows Terraform to delete the S3 bucket even if it contains objects. When false (default), Terraform will error if the bucket is not empty. This does NOT affect EBS volume lifecycle (EBS prevent_destroy is hardcoded in the module)."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "ARN of the KMS key to use for EBS volume encryption. If not specified, uses AWS-managed encryption keys. Applies to root, NVRAM, and metadata volumes."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
