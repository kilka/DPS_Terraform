# DDVE EC2 instance
resource "aws_instance" "ddve" {
  ami           = data.aws_ami.ddve.id
  instance_type = local.selected_config.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_pair_name

  # Attach security groups (module-created + additional)
  vpc_security_group_ids = local.security_group_ids

  # Attach IAM instance profile for S3 access
  iam_instance_profile = local.create_iam_role ? aws_iam_instance_profile.ddve[0].name : var.iam_role_name

  # Root block device configuration
  root_block_device {
    volume_type           = local.selected_config.root_disk_type
    volume_size           = local.selected_config.root_disk_size
    encrypted             = true
    delete_on_termination = true

    tags = merge(
      local.common_tags,
      {
        Name = "${var.name_tag}-root"
        Type = "Root"
      }
    )
  }

  # Enable IMDSv2 (Instance Metadata Service Version 2)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # IMDSv2 required
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # Enable detailed monitoring
  monitoring = true

  tags = merge(
    local.common_tags,
    {
      Name  = var.name_tag
      Model = var.model
    }
  )

  # Ensure volumes are created before instance
  depends_on = [
    aws_ebs_volume.nvram,
    aws_ebs_volume.metadata
  ]
}
