variable "storage_capacity" {
  description = "FSx storage capacity in GiB."
  type        = number
  default     = 32

  validation {
    condition     = var.storage_capacity >= 32
    error_message = "For SSD FSx for Windows, storage_capacity must be at least 32 GiB."
  }
}

variable "storage_type" {
  description = "FSx storage type."
  type        = string
  default     = "SSD"

  validation {
    condition     = contains(["SSD", "HDD"], var.storage_type)
    error_message = "storage_type must be SSD or HDD."
  }
}

variable "throughput_capacity" {
  description = "FSx throughput capacity in MBps."
  type        = number
  default     = 32

  validation {
    condition = contains(
      [8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4608, 6144, 9216, 12288],
      var.throughput_capacity
    )

    error_message = "throughput_capacity must be a supported FSx throughput value."
  }
}

variable "deployment_type" {
  description = "FSx deployment type."
  type        = string
  default     = "SINGLE_AZ_2"

  validation {
    condition = contains(
      ["SINGLE_AZ_1", "SINGLE_AZ_2", "MULTI_AZ_1"],
      var.deployment_type
    )

    error_message = "deployment_type must be SINGLE_AZ_1, SINGLE_AZ_2, or MULTI_AZ_1."
  }
}

variable "subnet_ids" {
  description = "Subnet IDs for the FSx file system."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "At least one subnet ID must be provided."
  }
}

variable "preferred_subnet_id" {
  description = "Preferred subnet for Multi-AZ FSx."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security groups attached to the FSx network interfaces."
  type        = list(string)
  default     = []
}

variable "active_directory_id" {
  description = "AWS Managed Microsoft AD directory ID."
  type        = string
}

variable "kms_key_id" {
  description = "Optional customer-managed KMS key ARN."
  type        = string
  default     = null
}

variable "automatic_backup_retention_days" {
  description = "Automatic backup retention in days. Set to 0 to disable."
  type        = number
  default     = 0

  validation {
    condition     = var.automatic_backup_retention_days >= 0 && var.automatic_backup_retention_days <= 90
    error_message = "automatic_backup_retention_days must be between 0 and 90."
  }
}

variable "daily_automatic_backup_start_time" {
  description = "Daily backup start time in UTC, HH:MM."
  type        = string
  default     = null
}

variable "weekly_maintenance_start_time" {
  description = "Weekly maintenance window in UTC, d:HH:MM."
  type        = string
  default     = null
}

variable "copy_tags_to_backups" {
  description = "Whether to copy tags to backups."
  type        = bool
  default     = false
}

variable "skip_final_backup" {
  description = "Whether to skip the final backup during deletion."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the FSx file system."
  type        = map(string)
  default     = {}
}