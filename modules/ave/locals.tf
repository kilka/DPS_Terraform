locals {
  # Model configurations (using current instance types from example)
  # Note: Fixed duplicate "4 TB AVE" key issue from original
  model_config = {
    "0.5TB" = {
      instance_type   = "m5.large"
      root_disk_type  = "gp3"
      root_disk_size  = 250
      data_disk_type  = "gp3"
      data_disk_size  = 250
      data_disk_count = 3
    }
    "1TB" = {
      instance_type   = "m5.large"
      root_disk_type  = "gp3"
      root_disk_size  = 250
      data_disk_type  = "gp3"
      data_disk_size  = 250
      data_disk_count = 6
    }
    "2TB" = {
      instance_type   = "m5.xlarge"
      root_disk_type  = "gp3"
      root_disk_size  = 250
      data_disk_type  = "gp3"
      data_disk_size  = 1000
      data_disk_count = 3
    }
    "4TB" = {
      instance_type   = "m5.2xlarge"
      root_disk_type  = "gp3"
      root_disk_size  = 250
      data_disk_type  = "gp3"
      data_disk_size  = 1000
      data_disk_count = 6
    }
    "8TB" = {
      instance_type   = "r5.2xlarge"
      root_disk_type  = "gp3"
      root_disk_size  = 250
      data_disk_type  = "gp3"
      data_disk_size  = 1000
      data_disk_count = 12
    }
    "16TB" = {
      instance_type   = "r5.4xlarge"
      root_disk_type  = "gp3"
      root_disk_size  = 250
      data_disk_type  = "gp3"
      data_disk_size  = 2000
      data_disk_count = 12
    }
  }

  # Device names for EBS volume attachments (AWS device naming convention)
  device_names = [
    "/dev/sdc",
    "/dev/sdd",
    "/dev/sde",
    "/dev/sdf",
    "/dev/sdg",
    "/dev/sdh",
    "/dev/sdi",
    "/dev/sdj",
    "/dev/sdk",
    "/dev/sdl",
    "/dev/sdm",
    "/dev/sdn",
  ]

  # Selected model configuration
  selected_config = local.model_config[var.model]

  # Security group IDs to attach (module-created + additional)
  security_group_ids = concat(
    [aws_security_group.ave.id],
    var.additional_security_group_ids
  )

  # Common tags
  common_tags = merge(
    {
      Name      = var.name_tag
      ManagedBy = "Terraform"
      Component = "AVE"
      Model     = var.model
    },
    var.tags
  )
}
