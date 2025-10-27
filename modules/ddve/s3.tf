# S3 bucket for DDVE storage (optional - only created if create_s3_bucket is true)
resource "aws_s3_bucket" "ddve" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = local.s3_bucket_name

  # When s3_force_destroy is true, allow Terraform to delete bucket even if it contains objects
  # When false (default), Terraform will error if bucket is not empty (safer for production)
  force_destroy = var.s3_force_destroy

  tags = merge(
    local.common_tags,
    {
      Name = local.s3_bucket_name
    }
  )
}

# Disable bucket versioning (required for DDVE - prevents cost and performance issues)
resource "aws_s3_bucket_versioning" "ddve" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.ddve[0].id

  versioning_configuration {
    status = "Disabled"
  }
}

# Enable server-side encryption with AES-256 (SSE-S3)
# DDVE supports SSE-S3 (recommended) and SSE-KMS. SSE-S3 is recommended to avoid KMS costs and throttling.
resource "aws_s3_bucket_server_side_encryption_configuration" "ddve" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.ddve[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "ddve" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.ddve[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# NOTE: S3 VPC Gateway Endpoint should be managed at the VPC level by cloud teams,
# not by this module. The endpoint is a VPC-wide resource that benefits all services,
# not just DDVE.
