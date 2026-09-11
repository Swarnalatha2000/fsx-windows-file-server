variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "active_directory_id" {
  description = "AWS Managed Microsoft AD directory ID."
  type        = string
}

variable "fsx_subnet_id" {
  description = "Subnet where the Single-AZ FSx file system will be deployed."
  type        = string
}

variable "fsx_security_group_id" {
  description = "Security group ID for FSx."
  type        = string
}

variable "fsx_name" {
  description = "Name tag for the FSx file system."
  type        = string
  default     = "fsx-windows-e2e"
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