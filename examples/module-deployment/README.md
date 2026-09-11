# FSx Windows Module Deployment

This example deploys Amazon FSx for Windows File Server using the reusable
module located at:

../../modules/fsx-windows

## Prerequisites

The following resources must already exist:

- AWS VPC
- AWS Managed Microsoft AD
- Subnet in the AD VPC
- FSx security group

The Windows EC2 instance is used later for E2E validation.

## Configure

Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars