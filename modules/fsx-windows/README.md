# FSx for Windows File Server Terraform Module

Reusable Terraform module for deploying Amazon FSx for Windows File Server.

## Scope

This module creates the FSx file system.

It does not create:

- VPC
- Subnets
- Active Directory
- Windows EC2
- Security groups
- IAM execution roles

Those are intentionally external dependencies so the module can be reused in existing environments.

## Required inputs

- `active_directory_id`
- `subnet_ids`

## Example

```hcl
module "fsx_windows" {
  source = "../../modules/fsx-windows"

  active_directory_id = var.active_directory_id

  subnet_ids = [
    var.fsx_subnet_id
  ]

  security_group_ids = [
    var.fsx_security_group_id
  ]

  storage_capacity    = 32
  storage_type        = "SSD"
  throughput_capacity = 32

  deployment_type = "SINGLE_AZ_2"

  tags = {
    Name        = "e2e-fsx-windows"
    Environment = "test"
  }
}