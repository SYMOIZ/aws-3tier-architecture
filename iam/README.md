# IAM Structure (SOP Phase 1)

| Object | Name | Purpose |
|--------|------|---------|
| Policy | `3tier-deploy-policy` | EC2, ELB, Resource Groups, tags, SSM AMI lookup in one region |
| Group | `3tier-admins` | Holds the policy |
| User | `3tier-deployer` | Day-to-day CLI/console deployer |

## Policy file

[policies/3tier-deploy-policy.json](policies/3tier-deploy-policy.json)

## Other sample

[policies/ec2-ssm-minimal-policy.json](policies/ec2-ssm-minimal-policy.json) — optional later for instance profiles (not required by the SOP scripts).

## Temporary root

Use root/admin **only** to create Phase 1 objects, then switch to `3tier-deployer`.
