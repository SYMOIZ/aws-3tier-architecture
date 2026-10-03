# IAM Structure

## Concepts (quick reference)

| Type | Use |
|------|-----|
| **User** | Human operator running CLI from laptop |
| **Group** | `nexusops-deployers` — attach deploy policies |
| **Policy** | JSON permissions document |
| **Role** | Assumed by EC2 via instance profile |
| **Instance profile** | Links role to EC2 |

**Difference:** Users have long-term credentials; roles are temporary credentials via STS.

## Planned groups (Part 02)

| Group | Purpose |
|-------|---------|
| `nexusops-deployers` | VPC, EC2, RDS, ELB create/describe for lab account |
| `nexusops-readonly` | Describe-only for reviewers |

## Temporary admin access

During very first account setup, some teams use broad admin **temporarily**. For this repo we target **scoped policies** in `policies/`. If you must use admin for a one-time bootstrap, document the date and remove it.

## Policy files

| File | Purpose |
|------|---------|
| [policies/ec2-ssm-minimal-policy.json](policies/ec2-ssm-minimal-policy.json) | Example EC2 role: SSM + CloudWatch logs |

Additional policies (`vpc-deploy`, `rds-deploy`, `elb-deploy`) will be added with Part 02 step `02-iam/`.

## Instance profiles (planned)

| Role | Attached to |
|------|-------------|
| `nexusops-ec2-base-role` | Frontend, Backend, Squid, VPN (tuned per host) |
