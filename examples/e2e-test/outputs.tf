output "fsx_file_system_id" {
  value = module.fsx_windows.file_system_id
}

output "fsx_dns_name" {
  description = "Use this DNS name from the Windows EC2 instance."
  value       = module.fsx_windows.dns_name
}

output "fsx_ip" {
  value = module.fsx_windows.preferred_file_server_ip
}

output "fsx_vpc_id" {
  value = module.fsx_windows.vpc_id
}

output "fsx_deployment_type" {
  value = module.fsx_windows.deployment_type
}