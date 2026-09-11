aws_region = "us-east-1"

active_directory_id = "d-90667ca260"

# These two subnets MUST be in different Availability Zones.
fsx_subnet_ids = [
  "subnet-0756ec6705c57cfe5", #us-east-1c
  "subnet-0c5b93c6d45d09d96"  #us-east-1b
]

# Must be one of the two subnet IDs above.
preferred_subnet_id = "subnet-0756ec6705c57cfe5"

fsx_security_group_id = "sg-04ee0dd3c055b184b"

fsx_name = "fsx-windows-multi-az-test"

storage_capacity    = 32
storage_type        = "SSD"
throughput_capacity = 32

automatic_backup_retention_days = 0
skip_final_backup               = true
