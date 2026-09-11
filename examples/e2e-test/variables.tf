variable "aws_region" {
  description = "AWS region where FSx will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "active_directory_id" {
  description = "AWS Managed Microsoft AD directory ID."
  type        = string
}

variable "fsx_subnet_ids" {
  description = "Exactly two subnet IDs in different Availability Zones for Multi-AZ FSx."
  type        = list(string)

  validation {
    condition     = length(var.fsx_subnet_ids) == 2
    error_message = "fsx_subnet_ids must contain exactly two subnet IDs for MULTI_AZ_1."
  }
}

variable "preferred_subnet_id" {
  description = "Preferred subnet ID. Must be one of fsx_subnet_ids."
  type        = string

  validation {
    condition     = contains(var.fsx_subnet_ids, var.preferred_subnet_id)
    error_message = "preferred_subnet_id must be one of the two fsx_subnet_ids."
  }
}

variable "fsx_security_group_id" {
  description = "Security group ID to associate with FSx."
  type        = string
}

variable "fsx_name" {
  description = "Name tag for the FSx file system."
  type        = string
  default     = "fsx-windows-multi-az-test"
}

variable "storage_capacity" {
  description = "FSx storage capacity in GiB."
  type        = number
  default     = 32
}

variable "storage_type" {
  description = "FSx storage type."
  type        = string
  default     = "SSD"
}

variable "throughput_capacity" {
  description = "FSx throughput capacity in MBps."
  type        = number
  default     = 32
}

variable "automatic_backup_retention_days" {
  description = "Number of days to retain automatic backups. Set to 0 to disable."
  type        = number
  default     = 0
}

variable "skip_final_backup" {
  description = "Whether to skip the final backup when destroying FSx."
  type        = bool
  default     = true
}
