# AVE EC2 instance
resource "aws_instance" "ave" {
  ami           = data.aws_ami.ave.id
  instance_type = local.selected_config.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_pair_name

  # Attach security groups (module-created + additional)
  vpc_security_group_ids = local.security_group_ids

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

  # Instance Metadata Service - Optional (allows both IMDSv1 and IMDSv2)
  # Note: AVE requires IMDSv1 on initial boot, but IMDSv2 can be enabled after deployment
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional" # Allow both IMDSv1 and IMDSv2
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

  # Ensure data volumes are created before instance
  depends_on = [
    aws_ebs_volume.data
  ]

  lifecycle {
    ignore_changes = [ami]
  }
}
