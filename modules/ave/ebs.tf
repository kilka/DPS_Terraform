# Root disk configuration is handled in ec2.tf as part of the instance configuration

# Data disks for AVE storage
resource "aws_ebs_volume" "data" {
  count = local.selected_config.data_disk_count

  availability_zone = data.aws_subnet.selected.availability_zone
  size              = local.selected_config.data_disk_size
  type              = local.selected_config.data_disk_type
  encrypted         = true
  kms_key_id        = var.kms_key_id

  tags = merge(
    local.common_tags,
    {
      Name  = "${var.name_tag}-data-${count.index + 1}"
      Type  = "Data"
      Index = count.index + 1
    }
  )
}
