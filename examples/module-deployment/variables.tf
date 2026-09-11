variable "aws_region" {
  description = "AWS region where FSx will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "active_directory_id" {
  description = "AWS Managed Microsoft AD directory ID."
  type        = string
}

variable "fsx_subnet_id" {
  description = "Subnet ID where the FSx file system will be deployed."
  type        = string
}

variable "fsx_security_group_id" {
  description = "Security group ID to associate with FSx."
  type        = string
}

variable "fsx_name" {
  description = "Name tag for the FSx file system."
  type        = string
  default     = "fsx-windows-test"
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

variable "deployment_type" {
  description = "FSx deployment type."
  type        = string
  default     = "SINGLE_AZ_2"
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