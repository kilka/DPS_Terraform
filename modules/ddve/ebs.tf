# Root disk configuration is handled in ec2.tf as part of the launch template

# NVRAM disk
resource "aws_ebs_volume" "nvram" {
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = local.selected_config.nvram_disk_size
  type              = local.selected_config.nvram_disk_type
  encrypted         = true
  kms_key_id        = var.kms_key_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_tag}-nvram"
      Type = "NVRAM"
    }
  )
  #CHANGE TO TRUE for prod
  lifecycle {
    prevent_destroy = false
  }
}

# Metadata disks
resource "aws_ebs_volume" "metadata" {
  count = local.metadata_disk_count

  availability_zone = data.aws_subnet.selected.availability_zone
  size              = local.selected_config.per_metadata_disk_size
  type              = local.selected_config.metadata_disk_type
  encrypted         = true
  kms_key_id        = var.kms_key_id

  tags = merge(
    local.common_tags,
    {
      Name  = "${var.name_tag}-metadata-${count.index + 1}"
      Type  = "Metadata"
      Index = count.index + 1
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}
