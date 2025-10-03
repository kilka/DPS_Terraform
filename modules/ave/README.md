# AVE (Avamar Virtual Edition) Terraform Module

This module deploys Dell Avamar Virtual Edition (AVE) to AWS with production-ready configurations.

## Features

- **Multiple Size Configurations**: Supports 0.5TB, 1TB, 2TB, 4TB, 8TB, and 16TB models
- **Automatic EBS Volume Management**: Creates and attaches data volumes based on selected model
- **Security Group Management**: Creates AVE-specific security group with all required ports
- **Encrypted Storage**: All volumes encrypted by default
- **IMDSv2 Enabled**: Instance Metadata Service Version 2 required
- **Flexible Network Integration**: Supports additional security groups from cloud team

## Usage

```hcl
module "ave" {
  source = "./modules/ave"

  name_tag    = "production-ave-01"
  model       = "2TB"
  ave_version = "19.9.0.0"

  # Network configuration
  vpc_id    = "vpc-12345678"
  subnet_id = "subnet-12345678"

  # Key pair for SSH access
  key_pair_name = "my-key-pair"

  # Security configuration
  allowed_ssh_cidr_blocks        = ["10.0.0.0/8"]
  allowed_management_cidr_blocks = ["10.0.0.0/8"]
  allowed_backup_cidr_blocks     = ["10.0.0.0/8", "172.16.0.0/12"]

  # Additional security groups from cloud team (optional)
  additional_security_group_ids = ["sg-87654321"]

  tags = {
    Environment = "production"
    Team        = "backup"
  }
}
```

## Model Configurations

| Model  | Instance Type | Data Disks | Disk Size | Total Storage |
|--------|---------------|------------|-----------|---------------|
| 0.5TB  | m5.large      | 3          | 250 GB    | 750 GB        |
| 1TB    | m5.large      | 6          | 250 GB    | 1.5 TB        |
| 2TB    | m5.xlarge     | 3          | 1000 GB   | 3 TB          |
| 4TB    | m5.2xlarge    | 6          | 1000 GB   | 6 TB          |
| 8TB    | r5.2xlarge    | 12         | 1000 GB   | 12 TB         |
| 16TB   | r5.4xlarge    | 12         | 2000 GB   | 24 TB         |

## Required Ports

The module creates a security group with the following ports based on Dell's official documentation:

### Inbound
- **SSH (22)**: CLI access and configuration
- **HTTPS (443)**: Web UI access
- **SNMP (161 TCP/UDP, 163 TCP/UDP)**: Monitoring
- **Avamar Core (700, 7543, 8543, 9090, 9443)**: Core services and UI
- **Backup Clients (7778-7781)**: Client communication
- **HFS (28001-28002)**: Hash file system
- **MCS (28810-28819)**: Management console service
- **GSAN (30001-30003)**: Grid storage area network
- **Replication (29000)**: Data replication
- **License (27000)**: License management

### Outbound
- All required ports for AWS services, DNS, NTP, replication, and backup operations

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name_tag | Name tag for AVE instance and volumes | string | - | yes |
| model | AVE model (0.5TB, 1TB, 2TB, 4TB, 8TB, 16TB) | string | "2TB" | no |
| ave_version | AVE version for AMI lookup | string | "19.9.0.0" | no |
| vpc_id | VPC ID for deployment | string | - | yes |
| subnet_id | Subnet ID for instance | string | - | yes |
| key_pair_name | EC2 key pair name | string | - | yes |
| allowed_ssh_cidr_blocks | CIDR blocks for SSH access | list(string) | [] | no |
| allowed_management_cidr_blocks | CIDR blocks for management access | list(string) | [] | no |
| allowed_backup_cidr_blocks | CIDR blocks for backup operations | list(string) | [] | no |
| additional_security_group_ids | Additional security groups to attach | list(string) | [] | no |
| tags | Additional resource tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | AVE EC2 instance ID |
| instance_arn | AVE EC2 instance ARN |
| private_ip | Private IP address |
| availability_zone | Deployment availability zone |
| security_group_id | AVE security group ID |
| data_volume_ids | Data volume IDs |
| model | Deployed model size |
| instance_type | EC2 instance type |
| data_disk_count | Number of data disks |
| ami_id | AMI ID used |

## Security Considerations

- All EBS volumes are encrypted by default
- IMDSv2 is required (IMDSv1 disabled)
- Security group rules support CIDR-based restrictions
- Additional security groups can be attached for cloud team policies
- No public IP assignment (private subnet deployment)

## Requirements

- Terraform >= 1.5.0
- AWS Provider >= 5.0
- Valid EC2 key pair
- VPC and subnet pre-configured by cloud team

## Post-Deployment

After deployment, you'll need to:

1. Access the AVE instance via SSH using the specified key pair
2. Complete initial configuration via CLI or web UI
3. Configure backup policies and clients
4. Set up replication if required

## Notes

- The module uses `lifecycle.ignore_changes` for AMI to prevent unwanted updates
- Data volumes are attached using `/dev/sdc` through `/dev/sdn` device names
- Root volume is 250GB GP3 (encrypted)
- All data volumes use GP3 type (encrypted)
