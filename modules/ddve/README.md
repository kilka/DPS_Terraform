# DDVE Terraform Module

This module deploys Dell Data Domain Virtual Edition (DDVE) on AWS with S3 Active Tier storage.

## Features

- **Production-Ready**: Based on Dell's official CloudFormation template
- **m6i Instance Types Only**: Optimized for latest generation instances (16TB, 32TB, 96TB, 256TB models)
- **IMDSv2 Enabled**: Instance Metadata Service Version 2 for enhanced security
- **Encrypted Storage**: All EBS volumes encrypted by default
- **IAM Role Management**: Creates IAM role with S3 permissions or uses existing role
- **S3 Integration**: Optional S3 bucket creation with VPC Gateway Endpoint support
- **Security Group**: DDVE-specific security group with support for additional groups
- **Multi-Region**: Supports all AWS regions including GovCloud and C2S

## Usage

### Basic Example

```hcl
module "ddve" {
  source = "./modules/ddve"

  name_tag          = "prod-ddve-01"
  model             = "32TB"
  vpc_id            = "vpc-12345678"
  subnet_id         = "subnet-12345678"
  key_pair_name     = "my-key-pair"
  s3_bucket_name    = "my-ddve-storage-bucket"
  create_s3_bucket  = true
  route_table_ids   = ["rtb-12345678"]

  allowed_ssh_cidr_blocks        = ["10.0.0.0/8"]
  allowed_management_cidr_blocks = ["10.0.0.0/8"]

  tags = {
    Environment = "Production"
    Team        = "Backup"
  }
}
```

### With Existing IAM Role

```hcl
module "ddve" {
  source = "./modules/ddve"

  name_tag          = "prod-ddve-01"
  model             = "96TB"
  iam_role_name     = "existing-ddve-role"
  vpc_id            = "vpc-12345678"
  subnet_id         = "subnet-12345678"
  key_pair_name     = "my-key-pair"
  s3_bucket_name    = "existing-ddve-bucket"
  create_s3_bucket  = false

  route_table_ids = ["rtb-12345678"]
}
```

### Custom Metadata Disk Count

```hcl
module "ddve" {
  source = "./modules/ddve"

  name_tag              = "prod-ddve-01"
  model                 = "256TB"
  metadata_disk_count   = 20  # Override default of 13
  vpc_id                = "vpc-12345678"
  subnet_id             = "subnet-12345678"
  key_pair_name         = "my-key-pair"
  s3_bucket_name        = "my-ddve-storage-bucket"
  create_s3_bucket      = true
  route_table_ids       = ["rtb-12345678"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_tag | Name tag for the DDVE EC2 instance and EBS volumes | `string` | n/a | yes |
| model | DDVE model selection (16TB, 32TB, 96TB, or 256TB) | `string` | `"16TB"` | no |
| metadata_disk_count | Number of metadata disks (1-24). If null, uses default for model | `number` | `null` | no |
| iam_role_name | Name of existing IAM role. If not provided, a new role will be created | `string` | `null` | no |
| s3_bucket_name | Name of S3 bucket for DDVE storage | `string` | n/a | yes |
| create_s3_bucket | Whether to create a new S3 bucket | `bool` | `false` | no |
| vpc_id | VPC ID where DDVE will be deployed | `string` | n/a | yes |
| subnet_id | Subnet ID where DDVE instance will be deployed | `string` | n/a | yes |
| additional_security_group_ids | Additional security group IDs to attach | `list(string)` | `[]` | no |
| key_pair_name | EC2 key pair name for SSH access | `string` | n/a | yes |
| aws_partition | AWS partition for IAM ARNs (aws, aws-us-gov, aws-iso) | `string` | `"aws"` | no |
| enable_s3_vpc_endpoint | Whether to create S3 VPC Gateway Endpoint | `bool` | `true` | no |
| route_table_ids | Route table IDs for S3 VPC endpoint | `list(string)` | `[]` | no |
| allowed_ssh_cidr_blocks | CIDR blocks allowed to SSH to DDVE | `list(string)` | `[]` | no |
| allowed_management_cidr_blocks | CIDR blocks allowed to access DDVE management | `list(string)` | `[]` | no |
| tags | Additional tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the DDVE EC2 instance |
| instance_arn | ARN of the DDVE EC2 instance |
| private_ip | Private IP address of the DDVE instance |
| availability_zone | Availability zone where DDVE is deployed |
| s3_bucket_name | Name of the S3 bucket |
| s3_bucket_arn | ARN of the S3 bucket (if created) |
| security_group_id | ID of the DDVE security group |
| iam_role_name | Name of the IAM role |
| iam_role_arn | ARN of the IAM role |
| nvram_volume_id | ID of the NVRAM EBS volume |
| metadata_volume_ids | IDs of the metadata EBS volumes |
| model | DDVE model deployed |
| instance_type | EC2 instance type used |
| metadata_disk_count | Number of metadata disks attached |

## DDVE Models

| Model | Instance Type | vCPU | RAM | Default Metadata Disks | Metadata Disk Size |
|-------|---------------|------|-----|------------------------|-------------------|
| 16TB  | m6i.xlarge    | 4    | 16 GB | 2 | 1024 GB |
| 32TB  | m6i.2xlarge   | 8    | 32 GB | 4 | 1024 GB |
| 96TB  | m6i.4xlarge   | 16   | 64 GB | 10 | 1024 GB |
| 256TB | m6i.8xlarge   | 32   | 128 GB | 13 | 2048 GB |

## Storage Configuration

- **Root Disk**: 250 GB gp3 (encrypted)
- **NVRAM Disk**: 10 GB gp3 (encrypted)
- **Metadata Disks**: Variable count and size based on model (encrypted)
- **S3 Storage**: Standard S3 class (Active Tier only)

## Important Notes

### S3 Bucket Requirements
- Bucket name must be ≤ 48 characters
- No dots (.) in bucket name (for hosted-style URLs)
- Bucket must be in same region as DDVE instance
- Bucket versioning must be DISABLED
- Do NOT set lifecycle rules on the bucket

### Network Requirements
- IPv4 only (IPv6 not supported)
- VPC Gateway Endpoint for S3 recommended
- Security group configured for DDVE-specific ports

### IAM Permissions
The module creates an IAM role with the following S3 permissions:
- `s3:ListBucket`
- `s3:GetObject`
- `s3:PutObject`
- `s3:DeleteObject`

### AWS Partition Support
- Standard AWS: `aws` (default)
- AWS GovCloud: `aws-us-gov`
- AWS C2S: `aws-iso`

## Post-Deployment

After deployment, you need to:

1. Access the DDVE instance via SSH or management UI
2. Configure the Data Domain system
3. Create object store profile using the S3 bucket
4. Configure backup applications to use DDVE

## References

- [Dell DDVE Documentation](https://www.dell.com/support/home/en-us/product-support/product/data-domain-virtual-edition)
- Based on Dell CloudFormation Template version 8.3.0.15-1161254
- Module follows AWS and Terraform best practices

## License

This module is for internal use. Refer to Dell licensing for DDVE software.
