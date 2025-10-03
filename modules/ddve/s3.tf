# S3 bucket for DDVE storage (optional - only created if create_s3_bucket is true)
resource "aws_s3_bucket" "ddve" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = var.s3_bucket_name

  tags = merge(
    local.common_tags,
    {
      Name = var.s3_bucket_name
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
