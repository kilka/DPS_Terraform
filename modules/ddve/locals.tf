locals {
  # Model configurations for m6i instances only (m5 variants excluded per requirements)
  model_config = {
    "16TB" = {
      instance_type            = "m6i.xlarge"
      root_disk_type          = "gp3"
      root_disk_size          = 250
      nvram_disk_type         = "gp3"
      nvram_disk_size         = 10
      metadata_disk_type      = "gp3"
      per_metadata_disk_size  = 1024
      metadata_disk_default_num = 1
    }
    "32TB" = {
      instance_type            = "m6i.2xlarge"
      root_disk_type          = "gp3"
      root_disk_size          = 250
      nvram_disk_type         = "gp3"
      nvram_disk_size         = 10
      metadata_disk_type      = "gp3"
      per_metadata_disk_size  = 1024
      metadata_disk_default_num = 4
    }
    "96TB" = {
      instance_type            = "m6i.4xlarge"
      root_disk_type          = "gp3"
      root_disk_size          = 250
      nvram_disk_type         = "gp3"
      nvram_disk_size         = 10
      metadata_disk_type      = "gp3"
      per_metadata_disk_size  = 1024
      metadata_disk_default_num = 10
    }
    "256TB" = {
      instance_type            = "m6i.8xlarge"
      root_disk_type          = "gp3"
      root_disk_size          = 250
      nvram_disk_type         = "gp3"
      nvram_disk_size         = 10
      metadata_disk_type      = "gp3"
      per_metadata_disk_size  = 2048
      metadata_disk_default_num = 13
    }
  }

  # AMI IDs per region (from CloudFormation template DdveConfigPerRegion mapping)
  # DDVE version: 8.3.0.15-1161254
  ami_ids = {
    "us-east-1"      = "ami-09e2f4b415eacc1b9"
    "us-east-2"      = "ami-07819bc4440456d53"
    "us-west-1"      = "ami-0640c8b30f400cbc0"
    "us-west-2"      = "ami-0785495d355b1b8ec"
    "us-gov-west-1"  = "ami-036e2bca87f0efd3b"
    "us-gov-east-1"  = "ami-051bd0985c5c07d98"
    "af-south-1"     = "ami-016192a498e642d62"
    "ap-east-1"      = "ami-05449eba2c58dd788"
    "ap-northeast-1" = "ami-02b84f1b43f9922c0"
    "ap-northeast-2" = "ami-0c5340ec27192c593"
    "ap-northeast-3" = "ami-07f9ecabf9dbdf9a7"
    "ap-south-1"     = "ami-0c47d4e2cbc7e6a09"
    "ap-southeast-1" = "ami-0ffd6fb0df642bf18"
    "ap-southeast-2" = "ami-0e95b05c8c73db88e"
    "ca-central-1"   = "ami-0f73c7f32d4ec1ece"
    "eu-central-1"   = "ami-0d7ee25d53c5ad8d3"
    "eu-north-1"     = "ami-0abc35dd93f64c42f"
    "eu-south-1"     = "ami-09d5eb81569835fa2"
    "eu-west-1"      = "ami-0d94f8764afbf1cde"
    "eu-west-2"      = "ami-04ff4f6b1dae73d9e"
    "eu-west-3"      = "ami-08e0f3bc12f0dbf81"
    "me-south-1"     = "ami-07bb9a8a74a12e1b1"
    "sa-east-1"      = "ami-0b7ed6764de1ab2d9"
  }

  # Selected model configuration
  selected_config = local.model_config[var.model]

  # Determine actual number of metadata disks (use override if provided, otherwise default)
  metadata_disk_count = coalesce(
    var.metadata_disk_count,
    local.selected_config.metadata_disk_default_num
  )

  # Security group IDs to attach (module-created + additional)
  security_group_ids = concat(
    [aws_security_group.ddve.id],
    var.additional_security_group_ids
  )

  # IAM role name (use provided or generated)
  iam_role_name = coalesce(var.iam_role_name, "${var.name_tag}-ddve-role")
  create_iam_role = var.iam_role_name == null

  # S3 bucket ARN based on AWS partition
  s3_bucket_arn = "${var.aws_partition}:s3:::${var.s3_bucket_name}"

  # Common tags
  common_tags = merge(
    {
      Name       = var.name_tag
      ManagedBy  = "Terraform"
      Component  = "DDVE"
      Model      = var.model
    },
    var.tags
  )
}
