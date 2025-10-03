# DDVE Lab Deployment Example

This example demonstrates deploying a complete DDVE lab environment including:
- Lab VPC with public/private subnets
- Windows Server 2025 jump host with RDP access
- DDVE instance in private subnet
- S3 bucket for DDVE storage

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **EC2 Key Pair** created in your target AWS region
3. **Terraform** >= 1.5.0 installed
4. **AWS CLI** configured with credentials

## Quick Start

### 1. Configure Variables

Copy the example variables file and customize:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
key_pair_name  = "your-ec2-keypair"
ddve_model     = "16TB"
s3_bucket_name = "ddve-lab-yourinitials-20241003"
owner_tag      = "Your Name"
```

**Important**:
- The EC2 key pair must already exist in AWS
- S3 bucket name must be globally unique, ≤48 characters, no dots

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Deploy

```bash
terraform apply
```

Review the plan and type `yes` to proceed. Deployment takes ~5-10 minutes.

### 5. Get Access Information

After deployment completes, Terraform will output connection details:

```bash
terraform output quick_start_guide
```

## Accessing Your Lab

### Step 1: Get Windows Password

```bash
# Use the command from terraform output
aws ec2 get-password-data \
  --instance-id <instance-id-from-output> \
  --priv-launch-key ~/.ssh/your-key.pem \
  --query PasswordData \
  --output text | base64 -d
```

### Step 2: Connect to Jump Host

```bash
# Get the RDP connection string
terraform output rdp_connection

# Or manually connect
mstsc /v:<jump_host_public_ip>
```

**Credentials**:
- Username: `Administrator`
- Password: (from Step 1)

### Step 3: Access DDVE from Jump Host

Once connected to the jump host via RDP:

1. **Open Chrome** (pre-installed)
2. **Navigate to DDVE Management UI**:
   ```
   https://<ddve_private_ip>
   ```
   (Get IP from: `terraform output ddve_private_ip`)

3. **Or SSH to DDVE** (using PuTTY or PowerShell):
   ```
   ssh sysadmin@<ddve_private_ip>
   ```

## What Gets Deployed

### Networking
- VPC (10.0.0.0/16)
- Public Subnet (10.0.1.0/24) - Jump host
- Private Subnet (10.0.2.0/24) - DDVE
- Internet Gateway
- NAT Gateway (for private subnet internet access)
- S3 VPC Gateway Endpoint

### Compute
- Windows Server 2025 jump host (t3.medium)
  - Public IP with RDP access
  - Chrome browser pre-installed
- DDVE instance (m6i.xlarge for 16TB model)
  - Private IP only
  - NVRAM and metadata disks attached

### Storage
- S3 bucket for DDVE (Standard S3, versioning disabled)
- EBS volumes for DDVE (encrypted)

### Security
- Security group for jump host (RDP from your IP)
- Security group for DDVE (management from VPC)
- IAM role for DDVE with S3 access

## Cost Estimate (us-east-1, approximate)

- **NAT Gateway**: ~$1/day (~$32/month)
- **Windows Jump Host** (t3.medium): ~$1/day (~$30/month)
- **DDVE Instance** (m6i.xlarge): ~$4/day (~$146/month)
- **EBS Volumes**: ~$0.30/day (~$10/month)
- **Elastic IPs**: Free while attached
- **S3 Storage**: Pay for what you use

**Daily Total**: ~$6/day when running

**💡 Cost Saving Tip**: Run `terraform destroy` when not using the lab!

## Common Operations

### View All Outputs

```bash
terraform output
```

### Get DDVE Private IP

```bash
terraform output ddve_private_ip
```

### Get Jump Host Public IP

```bash
terraform output jump_host_public_ip
```

### Destroy Everything

⚠️ **Warning**: This will delete all resources and data!

```bash
terraform destroy
```

## Customization

### Use a Different DDVE Model

In `terraform.tfvars`:

```hcl
ddve_model = "32TB"  # Options: 16TB, 32TB, 96TB, 256TB
```

### Disable NAT Gateway (Save ~$32/month)

In `main.tf`, add to the lab module:

```hcl
module "lab" {
  source = "../../modules/lab"
  # ... other settings ...

  enable_nat_gateway = false  # Private subnet has no internet
}
```

**Note**: DDVE can still access S3 via VPC endpoint, but cannot reach internet for updates.

### Use Existing S3 Bucket

In `main.tf`, modify the ddve module:

```hcl
module "ddve" {
  source = "../../modules/ddve"
  # ... other settings ...

  s3_bucket_name   = "my-existing-bucket"
  create_s3_bucket = false
}
```

## Troubleshooting

### Can't RDP to Jump Host

1. Check security group allows your current IP:
   ```bash
   terraform output allowed_rdp_cidr
   ```
2. If your IP changed, update and re-apply:
   ```bash
   terraform apply
   ```

### Can't Access DDVE from Jump Host

1. Verify DDVE is running:
   ```bash
   aws ec2 describe-instances --instance-ids <ddve-instance-id>
   ```
2. Check security groups allow access from VPC
3. Try SSH first to verify connectivity:
   ```
   ssh sysadmin@<ddve_private_ip>
   ```

### Deployment Fails

1. **Key Pair Not Found**: Ensure key pair exists in the correct region
2. **S3 Bucket Name Conflict**: Choose a different, globally unique name
3. **Quota Issues**: Check AWS service quotas for EC2, VPC, and EBS

## Next Steps

1. **Configure DDVE**: Follow Dell documentation to complete DDVE setup
2. **Create Object Store Profile**: Configure S3 bucket in DDVE
3. **Test Backups**: Connect backup software to DDVE
4. **Monitor Costs**: Check AWS Cost Explorer regularly

## Clean Up

When finished testing:

```bash
terraform destroy
```

Confirm with `yes` when prompted.

## References

- [DDVE Module Documentation](../../modules/ddve/README.md)
- [Lab Module Documentation](../../modules/lab/README.md)
- [Dell DDVE Documentation](https://www.dell.com/support/home/en-us/product-support/product/data-domain-virtual-edition)
