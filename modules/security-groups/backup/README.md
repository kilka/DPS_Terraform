# Backup Security Group Module

This module creates a comprehensive security group for Dell AVE/DDVE backup infrastructure that includes all required ports for communication between on-premises and AWS backup systems.

## Features

- **Bidirectional backup communication** between on-premises and AWS
- **Management host access** for administrative operations
- **DPA (Data Protection Advisor)** monitoring integration
- **External service connectivity** (NTP, DNS, SMTP, Dell ESRS)
- **Dell documentation-compliant** port configuration

## Port Groups

### On-Premises Backup Infrastructure
Bidirectional communication (ingress/egress) for:
- Echo/Registration (TCP 7)
- SSH (TCP 22)
- RPC Portmapper (TCP/UDP 111)
- HTTPS (TCP 443)
- Admin services (TCP 700, 8543, 9090)
- NFS (TCP/UDP 2049, 2052)
- DD Replication (TCP 2051)
- Archive tier (TCP 3008)
- SMS/System management (TCP 3009)
- Update Manager (TCP 7543)
- Admin services (TCP 7778-7781)
- App/Service tools (TCP 8443, 8888)
- AUI/Replication (TCP 9443)
- SNMP (TCP/UDP 161-163)
- Legacy connections (TCP 27000)
- MCS replication (TCP 28001-28010)
- Internal agents (TCP 28810-28819)
- SSL data path (TCP 29000)
- MCS/Avagent SSL (TCP 30001-30010)

### Management Hosts
Ingress only for:
- SSH (TCP 22)
- Web GUI (TCP 443)
- AVI (TCP 1234)
- AVI/SSL (TCP 7543)
- Avamar Console (TCP 7778-7781)
- AVI Downloader (TCP 8580)
- GUI/SSL (TCP 9443)

### DPA Server/Agent
Ingress only for:
- SSH (TCP 22)
- SNMP (UDP 161)
- Data Collection (TCP 5555)
- Rest API (TCP 8443)

### External Services
Egress only for:
- NTP (UDP 123)
- DNS (UDP 53)
- SMTP (TCP 25)
- Dell ESRS (TCP 443, 8443)

## Usage

```hcl
module "backup_sg" {
  source = "./modules/security-groups/backup"

  vpc_id = "vpc-12345678"
  name   = "backup-infrastructure-sg"

  # On-premises backup infrastructure (bidirectional)
  onprem_backup_cidr_blocks = ["10.0.0.0/8"]

  # On-premises management hosts (ingress only)
  onprem_mgmt_cidr_blocks = ["10.1.0.0/24"]

  # DPA servers/agents (ingress only)
  dpa_server_cidr_blocks = ["10.2.0.0/24"]

  # External services (egress only)
  ntp_server_ips  = ["169.254.169.123"]
  dns_server_ips  = ["10.0.0.2"]
  smtp_server_ips = ["10.0.0.10"]
  dell_esrs_ips   = ["143.166.84.118", "143.166.84.119"]

  tags = {
    Environment = "production"
    Team        = "backup-ops"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | VPC ID where the security group will be created | string | - | yes |
| name | Name tag for the security group | string | - | yes |
| name_prefix | Name prefix for the security group | string | "backup-sg-" | no |
| description | Description for the security group | string | "Security group for backup infrastructure..." | no |
| onprem_backup_cidr_blocks | CIDR blocks for on-premises backup infrastructure (bidirectional) | list(string) | [] | no |
| onprem_mgmt_cidr_blocks | CIDR blocks for on-premises management hosts (ingress) | list(string) | [] | no |
| dpa_server_cidr_blocks | CIDR blocks for DPA servers/agents (ingress) | list(string) | [] | no |
| ntp_server_ips | List of NTP server IP addresses (egress) | list(string) | [] | no |
| dns_server_ips | List of DNS server IP addresses (egress) | list(string) | [] | no |
| smtp_server_ips | List of SMTP server IP addresses (egress) | list(string) | [] | no |
| dell_esrs_ips | List of Dell ESRS IP addresses (egress) | list(string) | [] | no |
| tags | Additional tags to apply to the security group | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | ID of the backup security group |
| security_group_arn | ARN of the backup security group |
| security_group_name | Name of the backup security group |

## Notes

- All rules are created conditionally based on whether CIDR blocks or IPs are provided
- Rules follow Dell's backup infrastructure port requirements
- Security group supports both AVE and DDVE deployments
- Reference: aws_backup_ports_generic_csv.csv

## Security Considerations

- Review and adjust CIDR blocks to match your specific network topology
- Consider using more restrictive CIDR ranges where possible
- Regularly audit security group rules for compliance
- Test connectivity after deployment to ensure all required ports are accessible
