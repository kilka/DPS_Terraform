# Lab Infrastructure Module

This module creates a complete lab environment for testing DDVE and AVE deployments, including networking infrastructure and a Windows Server 2025 jump host.

## Features

- **Complete VPC Setup**: VPC with public and private subnets
- **Jump Host**: Windows Server 2025 with public IP for RDP access
- **NAT Gateway**: Optional NAT Gateway for private subnet internet access
- **S3 VPC Endpoint**: Gateway endpoint for S3 access from private subnet
- **Security Groups**: Pre-configured security groups for jump host and internal resources
- **Auto-Detection**: Automatically detects your public IP for RDP access

## Architecture

```
Internet
    |
    v
Internet Gateway
    |
    +-- Public Subnet (10.0.1.0/24)
    |       |
    |       +-- Windows Jump Host (public IP)
    |
    +-- NAT Gateway (optional)
            |
            v
        Private Subnet (10.0.2.0/24)
            |
            +-- DDVE/AVE instances
            |
            +-- S3 VPC Gateway Endpoint
```

## Usage

### Basic Example

```hcl
module "lab" {
  source = "./modules/lab"

  lab_name                = "my-dps-lab"
  jump_host_key_pair_name = "my-key-pair"

  tags = {
    Environment = "Lab"
    Project     = "DPS Testing"
  }
}

# Deploy DDVE in the lab environment
module "ddve" {
  source = "./modules/ddve"

  name_tag       = "lab-ddve-01"
  model          = "16TB"
  vpc_id         = module.lab.vpc_id
  subnet_id      = module.lab.private_subnet_id
  key_pair_name  = "my-key-pair"
  s3_bucket_name = "my-lab-ddve-bucket"
  create_s3_bucket = true
  route_table_ids  = [module.lab.private_route_table_id]

  # Use lab internal security group for jump host access
  additional_security_group_ids = [module.lab.lab_internal_security_group_id]

  # Allow SSH and management access from private subnet
  allowed_ssh_cidr_blocks        = [module.lab.vpc_cidr]
  allowed_management_cidr_blocks = [module.lab.vpc_cidr]
}
```

### Custom Configuration

```hcl
module "lab" {
  source = "./modules/lab"

  lab_name              = "custom-lab"
  vpc_cidr              = "172.16.0.0/16"
  public_subnet_cidr    = "172.16.10.0/24"
  private_subnet_cidr   = "172.16.20.0/24"
  jump_host_key_pair_name = "my-key-pair"

  # Specify custom RDP access CIDR
  allowed_rdp_cidr = "203.0.113.0/24"

  # Disable NAT Gateway for cost savings (no internet from private subnet)
  enable_nat_gateway = false

  tags = {
    Environment = "Development"
    Owner       = "Infrastructure Team"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |
| http | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |
| http | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| lab_name | Name prefix for all lab resources | `string` | `"dps-lab"` | no |
| vpc_cidr | CIDR block for the lab VPC | `string` | `"10.0.0.0/16"` | no |
| public_subnet_cidr | CIDR block for the public subnet | `string` | `"10.0.1.0/24"` | no |
| private_subnet_cidr | CIDR block for the private subnet | `string` | `"10.0.2.0/24"` | no |
| availability_zone | Availability zone for subnets | `string` | `null` (first AZ) | no |
| jump_host_instance_type | Instance type for Windows jump host | `string` | `"t3.medium"` | no |
| jump_host_key_pair_name | EC2 key pair name for jump host | `string` | n/a | yes |
| allowed_rdp_cidr | CIDR for RDP access (auto-detects if null) | `string` | `null` | no |
| enable_nat_gateway | Create NAT Gateway for private subnet | `bool` | `true` | no |
| tags | Additional tags for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the lab VPC |
| vpc_cidr | CIDR block of the lab VPC |
| public_subnet_id | ID of the public subnet |
| private_subnet_id | ID of the private subnet (for DDVE/AVE) |
| private_route_table_id | ID of the private route table |
| s3_vpc_endpoint_id | ID of the S3 VPC Gateway Endpoint |
| jump_host_id | ID of the Windows jump host |
| jump_host_public_ip | Public IP of the jump host |
| jump_host_private_ip | Private IP of the jump host |
| jump_host_security_group_id | ID of the jump host security group |
| lab_internal_security_group_id | ID of the lab internal security group |
| rdp_connection_string | RDP connection command |
| jump_host_password_command | Command to retrieve Windows password |

## Accessing the Jump Host

After deployment:

1. **Get the Windows Administrator Password**:
   ```bash
   aws ec2 get-password-data \
     --instance-id <instance-id> \
     --priv-launch-key /path/to/your/private-key.pem \
     --query PasswordData \
     --output text | base64 -d
   ```

2. **Connect via RDP**:
   ```bash
   mstsc /v:<jump_host_public_ip>
   ```
   Or use the output: `rdp_connection_string`

3. **From Jump Host**: Access DDVE/AVE management interfaces via private IPs using Chrome (pre-installed)

## Security Groups

### Jump Host Security Group
- **Inbound**: RDP (3389) from your public IP (auto-detected)
- **Outbound**: All traffic

### Lab Internal Security Group
- **Inbound**:
  - SSH (22) from jump host
  - HTTPS (443) from jump host
  - All traffic from other resources in the same security group
- **Outbound**: All traffic

## Cost Considerations

- **NAT Gateway**: ~$32/month + data transfer costs
  - Set `enable_nat_gateway = false` to reduce costs (disables internet from private subnet)
- **Jump Host**: t3.medium ~$30/month (when running)
- **Elastic IPs**: Free when attached, $3.60/month if unattached

## Best Practices

1. **Terminate Resources**: Always destroy lab resources when not in use
2. **Key Pair**: Keep your EC2 key pair secure (needed for Windows password)
3. **RDP Access**: The module auto-detects your public IP. If your IP changes, update the security group
4. **Subnet Sizing**: Default subnets support 251 hosts each (adequate for testing)

## Example: Complete Lab Deployment

```hcl
# Create lab infrastructure
module "lab" {
  source = "./modules/lab"

  lab_name                = "ddve-test-lab"
  jump_host_key_pair_name = "my-ec2-key"
}

# Deploy DDVE
module "ddve" {
  source = "./modules/ddve"

  name_tag                       = "test-ddve"
  model                          = "16TB"
  vpc_id                         = module.lab.vpc_id
  subnet_id                      = module.lab.private_subnet_id
  key_pair_name                  = "my-ec2-key"
  s3_bucket_name                 = "test-ddve-storage"
  create_s3_bucket               = true
  route_table_ids                = [module.lab.private_route_table_id]
  additional_security_group_ids  = [module.lab.lab_internal_security_group_id]
  allowed_ssh_cidr_blocks        = [module.lab.vpc_cidr]
  allowed_management_cidr_blocks = [module.lab.vpc_cidr]
}

# Outputs
output "rdp_to_jump_host" {
  value = module.lab.rdp_connection_string
}

output "ddve_private_ip" {
  value = module.ddve.private_ip
}

output "ddve_management_url" {
  value = "https://${module.ddve.private_ip}"
}
```

## Cleanup

To destroy all lab resources:

```bash
terraform destroy
```

**Note**: Ensure all DDVE/AVE instances are destroyed before destroying the lab module to avoid dependency issues.

## References

- [Windows Server 2025 Documentation](https://docs.microsoft.com/en-us/windows-server/)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
