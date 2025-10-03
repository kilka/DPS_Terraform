terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Configure AWS provider
provider "aws" {
  # Region can be set via AWS_REGION environment variable
  # or specified here:
  # region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = "DDVE-Lab"
    }
  }
}
