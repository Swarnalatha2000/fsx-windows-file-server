output "file_system_id" {
  description = "FSx file system ID."
  value       = aws_fsx_windows_file_system.this.id
}

output "file_system_arn" {
  description = "FSx file system ARN."
  value       = aws_fsx_windows_file_system.this.arn
}

output "dns_name" {
  description = "FSx DNS name used by Windows clients."
  value       = aws_fsx_windows_file_system.this.dns_name
}

output "preferred_file_server_ip" {
  description = "Preferred FSx file server IP."
  value       = aws_fsx_windows_file_system.this.preferred_file_server_ip
}

output "vpc_id" {
  description = "VPC containing the FSx file system."
  value       = aws_fsx_windows_file_system.this.vpc_id
}

output "deployment_type" {
  description = "FSx deployment type."
  value       = aws_fsx_windows_file_system.this.deployment_type
}