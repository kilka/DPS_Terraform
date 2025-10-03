variable "key_pair_name" {
  description = "Name of the EC2 key pair to use for jump host, AVE, and DDVE"
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
  default     = "16TB"
}

variable "s3_bucket_name" {
  description = "Name for the S3 bucket (must be globally unique, max 48 chars, no dots)"
  type        = string
}

variable "owner_tag" {
  description = "Owner tag for resources"
  type        = string
  default     = "Lab User"
}
