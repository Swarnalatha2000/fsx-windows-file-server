terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "fsx_windows" {
  source = "../../modules/fsx-windows"

  active_directory_id = var.active_directory_id

  subnet_ids = [
    var.fsx_subnet_id
  ]

  security_group_ids = [
    var.fsx_security_group_id
  ]

  storage_capacity    = var.storage_capacity
  storage_type        = var.storage_type
  throughput_capacity = var.throughput_capacity
  deployment_type     = var.deployment_type

  automatic_backup_retention_days = var.automatic_backup_retention_days
  skip_final_backup               = var.skip_final_backup

  tags = {
    Name        = var.fsx_name
    Environment = "test"
    ManagedBy   = "Terraform"
  }
}