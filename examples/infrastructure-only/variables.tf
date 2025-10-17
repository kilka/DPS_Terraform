variable "key_pair_name" {
  description = "EC2 key pair name for the jump host"
  type        = string
}

variable "owner_tag" {
  description = "Owner tag for all resources"
  type        = string
  default     = ""
}

variable "lab_name" {
  description = "Name prefix for lab resources"
  type        = string
  default     = "cfn-test-lab"
}

variable "s3_bucket_name" {
  description = "Name for the S3 bucket (must be globally unique, max 48 chars, no dots)"
  type        = string
}
