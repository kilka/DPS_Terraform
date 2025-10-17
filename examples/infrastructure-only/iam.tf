# IAM role for DDVE EC2 instance
resource "aws_iam_role" "ddve" {
  name        = "${var.lab_name}-ddve-role"
  description = "IAM role for DDVE instance with S3 access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.lab_name}-ddve-role"
    ManagedBy   = "Terraform"
    Environment = "Lab"
    Project     = "CloudFormation-Testing"
    Owner       = var.owner_tag
  }
}

# IAM policy for S3 bucket access
resource "aws_iam_role_policy" "ddve_s3" {
  name = "${var.lab_name}-ddve-s3-policy"
  role = aws_iam_role.ddve.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# IAM instance profile
resource "aws_iam_instance_profile" "ddve" {
  name = "${var.lab_name}-ddve-profile"
  role = aws_iam_role.ddve.name

  tags = {
    Name        = "${var.lab_name}-ddve-profile"
    ManagedBy   = "Terraform"
    Environment = "Lab"
    Project     = "CloudFormation-Testing"
    Owner       = var.owner_tag
  }
}
