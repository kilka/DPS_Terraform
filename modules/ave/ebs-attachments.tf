# Attach data volumes to AVE instance
resource "aws_volume_attachment" "data" {
  count = local.selected_config.data_disk_count

  device_name                    = local.device_names[count.index]
  volume_id                      = aws_ebs_volume.data[count.index].id
  instance_id                    = aws_instance.ave.id
  stop_instance_before_detaching = true
}
