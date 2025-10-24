# IAM role for DDVE EC2 instance
resource "aws_iam_role" "ddve" {
  count = local.create_iam_role ? 1 : 0

  name        = local.iam_role_name
  description = "IAM role for DDVE instance ${var.name_tag} with S3 access"

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

  tags = merge(
    local.common_tags,
    {
      Name = local.iam_role_name
    }
  )
}

# IAM policy for S3 bucket access
resource "aws_iam_role_policy" "ddve_s3" {
  count = local.create_iam_role ? 1 : 0

  name = "${local.iam_role_name}-s3-policy"
  role = aws_iam_role.ddve[0].id

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
          "arn:${var.aws_partition}:s3:::${local.s3_bucket_name}",
          "arn:${var.aws_partition}:s3:::${local.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# IAM instance profile
resource "aws_iam_instance_profile" "ddve" {
  count = local.create_iam_role ? 1 : 0

  name = "${local.iam_role_name}-profile"
  role = aws_iam_role.ddve[0].name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.iam_role_name}-profile"
    }
  )
}

# Data source for existing IAM role (if provided)
data "aws_iam_role" "existing" {
  count = local.create_iam_role ? 0 : 1
  name  = var.iam_role_name
}
