output "fsx_file_system_id" {
  description = "FSx file system ID."
  value       = module.fsx_windows.file_system_id
}

output "fsx_file_system_arn" {
  description = "FSx file system ARN."
  value       = module.fsx_windows.file_system_arn
}

output "fsx_dns_name" {
  description = "FSx DNS name used by Windows clients."
  value       = module.fsx_windows.dns_name
}

output "fsx_ip" {
  description = "Preferred FSx file server IP."
  value       = module.fsx_windows.preferred_file_server_ip
}

output "fsx_vpc_id" {
  description = "VPC containing the FSx file system."
  value       = module.fsx_windows.vpc_id
}

output "fsx_deployment_type" {
  description = "FSx deployment type."
  value       = module.fsx_windows.deployment_type
}