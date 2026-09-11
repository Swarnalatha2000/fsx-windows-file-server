resource "aws_fsx_windows_file_system" "this" {
  storage_capacity    = var.storage_capacity
  storage_type        = var.storage_type
  throughput_capacity = var.throughput_capacity

  deployment_type = var.deployment_type
  subnet_ids      = var.subnet_ids

  security_group_ids = var.security_group_ids

  active_directory_id = var.active_directory_id

  preferred_subnet_id = var.preferred_subnet_id

  kms_key_id = var.kms_key_id

  automatic_backup_retention_days   = var.automatic_backup_retention_days
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time

  copy_tags_to_backups = var.copy_tags_to_backups
  skip_final_backup    = var.skip_final_backup

  tags = var.tags
}