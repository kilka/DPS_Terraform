output "instance_id" {
  description = "ID of the AVE EC2 instance"
  value       = aws_instance.ave.id
}

output "instance_arn" {
  description = "ARN of the AVE EC2 instance"
  value       = aws_instance.ave.arn
}

output "private_ip" {
  description = "Private IP address of the AVE instance"
  value       = aws_instance.ave.private_ip
}

output "availability_zone" {
  description = "Availability zone where the AVE instance is deployed"
  value       = aws_instance.ave.availability_zone
}

output "data_volume_ids" {
  description = "IDs of the data EBS volumes"
  value       = aws_ebs_volume.data[*].id
}

output "model" {
  description = "AVE model deployed"
  value       = var.model
}

output "instance_type" {
  description = "EC2 instance type used"
  value       = local.selected_config.instance_type
}

output "data_disk_count" {
  description = "Number of data disks attached"
  value       = local.selected_config.data_disk_count
}

output "ami_id" {
  description = "AMI ID used for the AVE instance"
  value       = data.aws_ami.ave.id
}
