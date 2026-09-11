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

  automatic_backup_retention_days = 0
  skip_final_backup               = true

  tags = {
    Name = var.fsx_name
  }
}