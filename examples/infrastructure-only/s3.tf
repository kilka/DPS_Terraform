# S3 bucket for DDVE storage
resource "aws_s3_bucket" "ddve" {
  bucket        = var.s3_bucket_name
  force_destroy = true # Allow Terraform to delete bucket even if it contains objects

  tags = {
    Name        = var.s3_bucket_name
    ManagedBy   = "Terraform"
    Environment = "Lab"
    Project     = "CloudFormation-Testing"
    Owner       = var.owner_tag
  }
}

# Disable bucket versioning (required for DDVE - prevents cost and performance issues)
resource "aws_s3_bucket_versioning" "ddve" {
  bucket = aws_s3_bucket.ddve.id

  versioning_configuration {
    status = "Disabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "ddve" {
  bucket = aws_s3_bucket.ddve.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
