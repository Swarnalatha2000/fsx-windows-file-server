# FSx Windows E2E Test

This example is intended to prove the complete FSx for Windows File Server
deployment and Windows client access.

## Architecture

AWS Managed Microsoft AD
        |
        v
FSx for Windows File Server
        |
        | SMB TCP/445
        v
Windows EC2
        |
        v
\\<FSx-DNS-name>\share

## Prerequisites

Before running Terraform, the following must exist:

1. VPC
2. AWS Managed Microsoft AD
3. Subnet for FSx
4. Security group
5. Windows EC2 instance for validation

The Windows EC2 instance should be in the same VPC and should have network
connectivity to the Active Directory and FSx.

## Deploy

Copy the example variables:

```bash
cp terraform.tfvars.example terraform.tfvars