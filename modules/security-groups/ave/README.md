# AVE Security Group Module

This module creates a centralized security group for Dell Avamar Virtual Edition (AVE) instances with all required ports configured per Dell's official documentation.

## Features

- **Complete port configuration** for AVE management, backup, and data operations
- **Reusable across multiple AVE instances** for centralized security management
- **CIDR-based access controls** for SSH, management, and data ports
- **Enterprise-ready** for separation of network and application teams

## Usage

### Basic Example

```hcl
module "ave_security_group" {
  source = "./modules/security-groups/ave"

  vpc_id      = "vpc-12345678"
  name        = "shared-ave-sg"
  name_prefix = "prod-ave-"

  # Allow SSH from management network
  allowed_ssh_cidr_blocks = ["10.0.0.0/8"]

  # Allow management interfaces from corporate network
  allowed_management_cidr_blocks = ["10.0.0.0/8"]

  # Allow backup/data traffic from backup network
  allowed_data_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]

  tags = {
    Environment = "Production"
    Team        = "Backup"
    ManagedBy   = "CloudTeam"
  }
}

# Use the security group with multiple AVE instances
module "ave_01" {
  source = "./modules/ave"

  name_tag           = "prod-ave-01"
  security_group_ids = [module.ave_security_group.security_group_id]
  # ...
}

module "ave_02" {
  source = "./modules/ave"

  name_tag           = "prod-ave-02"
  security_group_ids = [module.ave_security_group.security_group_id]
  # ...
}
```

### Enterprise Pattern - Remote State

```hcl
# In core-infrastructure repository (managed by cloud team)
module "ave_security_group" {
  source = "git::ssh://git@github.com/company/terraform-modules//security-groups/ave"

  vpc_id                         = var.vpc_id
  name                           = "enterprise-ave-sg"
  allowed_ssh_cidr_blocks        = ["10.0.0.0/8"]
  allowed_management_cidr_blocks = ["10.0.0.0/8"]
  allowed_data_cidr_blocks       = ["10.0.0.0/8", "172.16.0.0/12"]

  tags = {
    CostCenter = "IT-BACKUP"
    DataClass  = "Confidential"
    Compliance = "SOX,PCI-DSS"
  }
}

output "ave_sg_id" {
  value = module.ave_security_group.security_group_id
}

# In application repository (managed by backup team)
data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = "company-terraform-state"
    key    = "core-infrastructure/terraform.tfstate"
  }
}

module "ave_instance" {
  source = "git::ssh://git@github.com/company/terraform-modules//ave"

  name_tag           = "prod-ave-01"
  security_group_ids = [data.terraform_remote_state.core.outputs.ave_sg_id]
  # ...
}
```

## Required Ports

### Inbound

- **SSH (22)**: CLI access and configuration, AVE to DDVE communication
- **HTTPS (443)**: Web UI access
- **SNMP (161 TCP/UDP, 163 TCP/UDP)**: Monitoring
- **Avamar Core (700, 7543, 8543, 9090, 9443)**: Core services and UI
- **Backup Clients (7778-7781)**: Client communication
- **HFS (28001-28002)**: Hash file system
- **MCS (28810-28819)**: Management console service
- **GSAN (30001-30010)**: Grid storage area network
- **Replication (29000)**: Data replication
- **License (27000)**: License management
- **DD Boost (2051)**: Data Domain Boost and replication from DDVE
- **ICMP**: All types allowed

### Outbound

- All required ports for AWS services, DNS, NTP, replication, and backup operations

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID where security group will be created | `string` | n/a | yes |
| name | Name tag for the security group | `string` | n/a | yes |
| name_prefix | Name prefix for the security group | `string` | `"ave-sg-"` | no |
| description | Description for the security group | `string` | `"Security group for AVE instances with all required ports"` | no |
| allowed_ssh_cidr_blocks | CIDR blocks allowed to SSH to AVE | `list(string)` | `[]` | no |
| allowed_management_cidr_blocks | CIDR blocks allowed to access management interfaces | `list(string)` | `[]` | no |
| allowed_data_cidr_blocks | CIDR blocks allowed to access backup/data ports | `list(string)` | `[]` | no |
| tags | Additional tags for the security group | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | ID of the AVE security group |
| security_group_arn | ARN of the AVE security group |
| security_group_name | Name of the AVE security group |

## Requirements

- Terraform >= 1.5.0
- AWS Provider >= 5.0

## Notes

- This security group is designed to be shared across multiple AVE instances
- ICMP is allowed from all sources (0.0.0.0/0) as per Dell's recommendations
- Egress rules allow all necessary outbound traffic
- Security group uses `name_prefix` with `create_before_destroy` lifecycle for safe updates

## Reference

Based on Dell Avamar Virtual Edition Installation and Upgrade Guide - Security Group Settings
