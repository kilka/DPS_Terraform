# Attach NVRAM disk to DDVE instance
# Device name /dev/sdb
resource "aws_volume_attachment" "nvram" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.nvram.id
  instance_id = aws_instance.ddve.id
}

# Attach metadata disks to DDVE instance
# Device names start from /dev/sdc and increment
resource "aws_volume_attachment" "metadata" {
  count = local.metadata_disk_count

  # Device naming: /dev/sdc, /dev/sdd, /dev/sde, etc.
  device_name = "/dev/sd${substr("cdefghijklmnopqrstuvwxyz", count.index, 1)}"
  volume_id   = aws_ebs_volume.metadata[count.index].id
  instance_id = aws_instance.ddve.id
}
