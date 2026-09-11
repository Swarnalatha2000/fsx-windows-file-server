FSx for Windows File Server — Issues Observed and Resolutions

1. Purpose

This document records the issues encountered while deploying and validating Amazon FSx for Windows File Server with AWS Managed Microsoft AD using Terraform.

It is intended to provide a troubleshooting history and the resolution applied for each issue.

2. Terraform Executed from Empty Repository Root

Symptom

Running Terraform initialization from the repository root produced an empty-directory message because the root did not contain Terraform configuration files.

Cause

The Terraform deployment configuration was intentionally located under:

examples/module-deployment/

Resolution

Terraform commands were executed from the example deployment directory:

cd examples/module-deployment
terraform init
terraform validate
terraform plan
terraform apply

Lesson

A repository can contain reusable modules without having a root Terraform deployment. Terraform must be executed from the directory containing the desired root module configuration.

3. AWS CLI / Terraform Credential Error

Symptom

Terraform initially failed because it was not using the intended AWS IAM role credentials.

Cause

The AWS CLI was authenticated using an AWS SSO profile named:

fsx-role

but Terraform was not yet configured to use that profile.

Resolution

The AWS profile was selected for the shell:

export AWS_PROFILE=fsx-role

Identity was verified with:

aws sts get-caller-identity --profile fsx-role

The assumed role was:

FSxDeploymentRole

Lesson

Always verify the AWS identity before running Terraform:

aws sts get-caller-identity

4. IAM Permission: fsx

Symptom

Terraform received an AccessDenied error for:

fsx:CreateFileSystem

Cause

The deployment role did not initially have the required FSx API permission.

Resolution

The required FSx permissions were added to the Terraform deployment role.

Lesson

The Terraform execution role should contain the minimum permissions required for the resources it manages.

5. IAM Permission: iam

Symptom

FSx deployment failed because the Terraform role could not create the FSx service-linked role.

Cause

Amazon FSx uses the service-linked role:

AWSServiceRoleForAmazonFSx

The Terraform execution role initially lacked permission to create it.

Resolution

A scoped permission was added:

{
  "Effect": "Allow",
  "Action": "iam:CreateServiceLinkedRole",
  "Resource": "arn:aws:iam::888577029290:role/aws-service-role/fsx.amazonaws.com/AWSServiceRoleForAmazonFSx",
  "Condition": {
    "StringEquals": {
      "iam:AWSServiceName": "fsx.amazonaws.com"
    }
  }
}

Important

The FSx service-linked role was not attached to the Terraform role. It is a separate AWS service role used by FSx.

6. IAM Permission: ds

Symptom

FSx deployment failed with an AccessDenied error for:

ds:DescribeDirectories

Cause

Terraform/FSx needed to validate the AWS Managed Microsoft AD directory, but the deployment role did not have the required Directory Service read permission.

Resolution

The following permission was added:

{
  "Effect": "Allow",
  "Action": "ds:DescribeDirectories",
  "Resource": "*"
}

7. FSx Failed Because of Active Directory Network Connectivity

Symptom

Early FSx creation attempts failed during Active Directory configuration.

The FSx service reported missing connectivity to required AD ports.

Cause

The FSx security group's outbound rules did not initially allow all required traffic to the Managed Microsoft AD security group.

Required traffic includes AD/DNS/RPC-related ports such as:

UDP 53
UDP 88
UDP 123
UDP 389
UDP 464

TCP 53
TCP 88
TCP 135
TCP 389
TCP 445
TCP 464
TCP 636
TCP 3268
TCP 3269
TCP 5985
TCP 9389
TCP 49152-65535

Resolution

The FSx security group outbound rules were updated to permit the required AD traffic to the Managed Microsoft AD security group.

The AD security group was also checked/updated to allow the corresponding inbound traffic from the required source network/security group.

Additional Correction

TCP port 9389 was initially missing/incorrectly configured and was corrected.

UDP port 88 was also corrected after initially being configured as TCP.

Lesson

FSx for Windows File Server requires reliable connectivity to the domain controllers during AD integration. Security group rules must be planned before deployment.

8. FSx and EC2 Security Groups Do Not Need to Be the Same

Question / Concern

The Windows EC2 instance and FSx used different security groups.

Resolution

This is valid and preferable for least-privilege network segmentation.

The FSx security group allowed:

Inbound TCP 445 from the Windows EC2 security group

The EC2 security group was configured to allow the required outbound SMB traffic to FSx.

Security groups are stateful, so a separate inbound return rule on the EC2 security group was not required solely for the response traffic.

9. Windows EC2 Could Not Resolve the FSx DNS Name

Symptom

The Windows EC2 initially failed to resolve:

amznfsxvh07mra3.raj.qrm.internal

when using its default DNS server:

10.0.0.2

Investigation

The AD DNS servers:

10.0.157.213
10.0.173.1

successfully resolved the FSx hostname.

A second working Windows EC2 was checked and was using:

10.0.157.213
10.0.173.1

as its DNS servers.

Cause

The non-working EC2 had a different DNS configuration/path from the working EC2. It was using AmazonProvidedDNS (10.0.0.2) without successfully resolving the Managed AD DNS zone in this environment.

Resolution

The Windows EC2 was configured/validated to use the Managed Microsoft AD DNS servers.

After the correct DNS path was available, the FSx hostname resolved successfully.

Lesson

For Windows clients accessing AD-integrated FSx, DNS resolution of the AD domain and FSx DNS name is a prerequisite for Kerberos/SMB access.

10. Direct IP SMB Access Returned Access Denied

Symptom

The following test reached the FSx server but returned access denied:

dir \10.0.161.230\share

Cause

The test used the FSx IP address and the current Windows session was a local account:

ec2amaz-l3qka0l\ssm-user

The correct FSx access pattern uses the FSx DNS name and an AD-authenticated identity.

Resolution

The test was changed to:

\amznfsxvh07mra3.raj.qrm.internal\share

and an AD account was used:

rajqrm\Admin

The SMB mapping then completed successfully.

Lesson

Do not use the FSx IP address as the final application access test. Use the FSx DNS name so that Windows authentication and FSx failover behavior work correctly.

11. Local SSM User Received Access Denied

Symptom

The following identity was shown:

ec2amaz-l3qka0l\ssm-user

and access to the FSx share returned:

Access is denied

Cause

ssm-user is a local Windows account on the EC2 instance, not an AD domain identity.

Resolution

The share was mapped using the Managed Microsoft AD administrator identity:

rajqrm\Admin

using:

net use Z: \amznfsxvh07mra3.raj.qrm.internal\share /user:rajqrm\Admin

The command completed successfully.

Lesson

Domain joining the EC2 does not automatically mean every Windows session is an AD user. The SMB test must use an appropriate AD identity.

12. RSAT Active Directory Module Warning

Symptom

The Active Directory PowerShell module was available, but AD queries produced a warning about Active Directory Web Services.

Cause

The EC2's AD connectivity/configuration was still being validated, and the required AD Web Services path was not available through the current network configuration.

Resolution

This was not treated as an FSx deployment failure because the FSx filesystem itself successfully integrated with the Managed AD and SMB access was subsequently validated.

The Windows client DNS/network configuration was corrected and the actual FSx SMB access test was completed successfully.

13. FSx Validation ZIP Could Not Be Downloaded

Symptom

Downloading the FSx AD validation package from the private Windows EC2 failed.

Cause

The private EC2 did not have outbound Internet access/NAT connectivity required for the download.

Resolution

Manual validation was performed using:

Domain membership

DNS resolution

TCP 445

AD authentication

SMB share access

File create/read/modify/delete

Lesson

Failure to download a validation package from a private subnet does not by itself indicate an FSx or AD problem.

14. CloudTrail Service-Linked Role Cleanup Event

Symptom

CloudTrail showed an FSx service-linked-role cleanup operation such as:

AWSServiceRoleForAmazonFSx
UnauthorizeApplication

Cause

This was associated with FSx service cleanup and did not indicate deletion of the AWS Managed Microsoft AD directory.

Resolution

No AD deletion action was taken. The Managed AD remained intact while failed FSx resources were destroyed/recreated.

15. Failed FSx Resources Were Destroyed

Symptom

Early FSx deployment attempts created failed resources.

Resolution

Terraform destroy was used to remove the failed FSx resources before subsequent deployment attempts.

The destroy operation targeted the Terraform-managed FSx resource; it did not mean deleting the VPC, subnet, EC2, or Managed Microsoft AD unless those resources were also managed by the same Terraform state.

16. Final Single-AZ Result

After resolving the IAM, security group, DNS, and authentication issues:

FSx ID:        fs-0cc8a26c0b98e67e6
Lifecycle:     AVAILABLE
Deployment:    SINGLE_AZ_2
AD:            raj.qrm.internal
DNS:           amznfsxvh07mra3.raj.qrm.internal

The Windows EC2 successfully:

Resolved the FSx DNS name

Connected to TCP 445

Authenticated using the AD administrator account

Accessed the share SMB share

Created a file

Read the file

Modified the file

Deleted the file

The Single-AZ deployment was therefore successfully validated end to end.

17. Lessons Learned

Verify the Terraform AWS identity before deployment.

Plan least-privilege IAM permissions for FSx and Directory Service.

Allow all required FSx-to-AD network ports before deployment.

Keep FSx and EC2 security groups separate when possible.

Ensure Windows clients can resolve the Managed AD DNS domain.

Use the FSx DNS name instead of the FSx IP for SMB access.

Domain-joined machines can still have local Windows sessions.

Validate actual SMB file operations rather than stopping at AVAILABLE.

Keep failed FSx resources separate from persistent shared infrastructure such as VPC and Managed AD.

Capture command output/screenshots as evidence before moving to the next deployment architecture.