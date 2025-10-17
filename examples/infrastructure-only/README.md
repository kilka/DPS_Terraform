# Infrastructure-Only Lab Deployment

This example deploys only the base infrastructure (VPC, subnets, and jump host) without AVE or DDVE instances. Use this to test CloudFormation templates in the AWS Console.

## What Gets Deployed

- **VPC** with DNS support enabled
- **Public subnet** with Internet Gateway for jump host
- **Private subnet** for AVE/DDVE instances
- **Windows Server 2022 jump host** in public subnet
- **S3 VPC Gateway Endpoint** attached to private route table (required for DDVE)
- **Security groups** for jump host access

## Prerequisites

1. AWS account with appropriate permissions
2. EC2 key pair created in your target region
3. Terraform >= 1.0 installed
4. AWS CLI configured (for retrieving Windows password)

## Deployment Steps

1. **Copy the example tfvars file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars with your values:**
   ```hcl
   key_pair_name = "your-key-pair-name"
   owner_tag     = "YourName"
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the plan:**
   ```bash
   terraform plan
   ```

5. **Deploy:**
   ```bash
   terraform apply
   ```

## Accessing the Jump Host

After deployment, Terraform will output the jump host public IP and connection details.

1. **Get the Windows administrator password:**
   ```bash
   aws ec2 get-password-data \
     --instance-id <instance-id-from-output> \
     --priv-launch-key /path/to/your/private-key.pem \
     --query 'PasswordData' \
     --output text | base64 -d
   ```

2. **Connect via RDP:**
   - Use the public IP from Terraform outputs
   - Username: `Administrator`
   - Password: from step 1

## Using CloudFormation Templates

After deployment, use the Terraform outputs to populate CloudFormation parameters:

```bash
terraform output cloudformation_parameters
```

This will show you values like:
- **VpcId** - Use for VPC selection in CloudFormation
- **SubnetId** - Use for private subnet (AVE/DDVE instances)
- **PublicSubnetId** - Use if you need public subnet
- **S3EndpointId** - S3 VPC endpoint (already configured)
- **JumpHostPrivateIP** - For security group rules
- **AllowedCIDR** - VPC CIDR for security group rules

### Example CloudFormation Deployment

1. Log into AWS Console
2. Navigate to CloudFormation
3. Create new stack
4. Upload your template (AVE or DDVE)
5. Use Terraform output values for parameters:
   - VPC ID: `terraform output vpc_id`
   - Subnet ID: `terraform output private_subnet_id`
   - Security group settings: Allow from VPC CIDR
6. Deploy and test

## What's NOT Deployed

This template does **NOT** deploy:
- AVE instances
- DDVE instances
- Additional EBS volumes
- S3 buckets for DDVE

These should be deployed via CloudFormation templates for testing.

## Cost Considerations

Resources deployed:
- 1x Windows Server 2022 t3.medium (~$0.05/hour)
- 1x Elastic IP (~$0.005/hour when attached)
- Data transfer costs (minimal for testing)

Estimated cost: ~$1-2/day

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note:** Make sure to delete any CloudFormation stacks you created before running `terraform destroy`.

## Customization

You can customize the deployment by modifying `main.tf`:

```hcl
module "lab" {
  source = "../../modules/lab"

  lab_name                = "my-custom-lab"
  jump_host_key_pair_name = var.key_pair_name

  # Custom VPC settings
  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"

  # Different availability zone
  availability_zone = "us-east-1a"

  # Larger jump host
  jump_host_instance_type = "t3.large"

  # Specific RDP access (instead of auto-detecting your IP)
  allowed_rdp_cidr = "1.2.3.4/32"

  tags = {
    Environment = "Testing"
    Project     = "MyProject"
  }
}
```

## Troubleshooting

### Can't retrieve Windows password
- Wait 5-10 minutes after instance launch
- Password encryption takes time to initialize

### Can't RDP to jump host
- Check your current public IP hasn't changed
- Verify security group allows your IP
- Check RDP is enabled on the instance

### S3 VPC endpoint not working
- Verify endpoint is attached to private route table
- Check security groups allow outbound HTTPS (443)
- Ensure DDVE/AVE instances are in private subnet
