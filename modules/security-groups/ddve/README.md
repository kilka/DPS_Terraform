# DDVE Security Group Module

This module creates a centralized security group for Dell Data Domain Virtual Edition (DDVE) instances with all required ports configured per Dell's official documentation.

## Features

- **Complete port configuration** for DDVE management and data operations
- **Reusable across multiple DDVE instances** for centralized security management
- **CIDR-based access controls** for SSH, management, and data ports
- **Enterprise-ready** for separation of network and application teams

## Usage

### Basic Example

```hcl
module "ddve_security_group" {
  source = "./modules/security-groups/ddve"

  vpc_id      = "vpc-12345678"
  name        = "shared-ddve-sg"
  name_prefix = "prod-ddve-"

  # Allow SSH from management network
  allowed_ssh_cidr_blocks = ["10.0.0.0/8"]

  # Allow management interfaces from corporate network
  allowed_management_cidr_blocks = ["10.0.0.0/8"]

  # Allow data traffic from backup network and AVE instances
  allowed_data_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]

  tags = {
    Environment = "Production"
    Team        = "Backup"
    ManagedBy   = "CloudTeam"
  }
}

# Use the security group with multiple DDVE instances
module "ddve_01" {
  source = "./modules/ddve"

  name_tag           = "prod-ddve-01"
  security_group_ids = [module.ddve_security_group.security_group_id]
  # ...
}

module "ddve_02" {
  source = "./modules/ddve"

  name_tag           = "prod-ddve-02"
  security_group_ids = [module.ddve_security_group.security_group_id]
  # ...
}
```

## Required Ports

### Inbound

- **SSH (22)**: CLI access, AVE to DDVE communication
- **HTTPS (443)**: DDSM (Data Domain System Manager) GUI
- **RPC (111 TCP/UDP)**: RPC portmapper for NFS
- **SNMP (161 TCP/UDP, 163 TCP/UDP)**: Monitoring
- **NFS/DD Boost (2049 TCP/UDP)**: Main data transfer port
- **Replication/DD Boost (2051)**: Replication and DD Boost operations
- **Data Domain Replication (2052)**: DD replication from AVE
- **SMS (3009)**: System Management Service for remote DDSM management

### Outbound

- **NTP (123 UDP)**: Time synchronization
- **DNS (53 TCP/UDP)**: Name resolution
- **HTTP (80)**: Package updates and AWS metadata
- **HTTPS (443)**: AWS services and S3
- **NFS/DD Boost (2049)**: Outbound data transfer
- **Replication (2051)**: Outbound replication
- **SNMP (161 TCP/UDP, 163 TCP/UDP)**: Outbound monitoring
- **SMS (3009)**: Outbound SMS

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | VPC ID where security group will be created | `string` | n/a | yes |
| name | Name tag for the security group | `string` | n/a | yes |
| name_prefix | Name prefix for the security group | `string` | `"ddve-sg-"` | no |
| description | Description for the security group | `string` | `"Security group for DDVE instances with all required ports"` | no |
| allowed_ssh_cidr_blocks | CIDR blocks allowed to SSH to DDVE | `list(string)` | `[]` | no |
| allowed_management_cidr_blocks | CIDR blocks allowed to access management interfaces | `list(string)` | `[]` | no |
| allowed_data_cidr_blocks | CIDR blocks allowed to access data ports | `list(string)` | `[]` | no |
| tags | Additional tags for the security group | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | ID of the DDVE security group |
| security_group_arn | ARN of the DDVE security group |
| security_group_name | Name of the DDVE security group |

## Requirements

- Terraform >= 1.5.0
- AWS Provider >= 5.0

## Notes

- This security group is designed to be shared across multiple DDVE instances
- S3 access requires S3 VPC Gateway Endpoint (managed separately)
- Security group uses `name_prefix` with `create_before_destroy` lifecycle for safe updates
- IPv6 is NOT supported by DDVE

## Reference

Based on Data Domain Virtual Edition Best Practices Guide - Inbound/Outbound Ports
