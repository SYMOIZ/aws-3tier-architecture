# Part 02 — Build AWS Infrastructure

## Objective

Create AWS resources in **dependency order**. Do not skip validation between major steps.

## Status

Step folders and CLI/IaC implementations are added **one phase at a time** after Part 01. Use this document as the master sequence when those steps land.

## Deployment order and why

| Step | Folder (planned) | Why this order |
|------|------------------|----------------|
| 01 | `01-prerequisites/` | Region, AWS CLI, naming, **your public IP** |
| 02 | `02-iam/` | Roles/policies before EC2 instance profiles |
| 03 | `03-vpc/` | Network container for everything else |
| 04 | `04-subnets/` | Requires VPC CIDR plan |
| 05 | `05-routing/` | IGW + route tables need subnets |
| 06 | `06-security-groups/` | Requires VPC ID; before any ENI |
| 07 | `07-network-validation/` | Prove routes/SG before compute |
| 08 | `07-vpn/` | Admin path into private subnets |
| 09 | `08-forward-proxy-squid/` | Egress path for private instances |
| 10 | `09-ec2/` | Compute needs subnets + SGs + proxy/VPN |
| 11 | `09-database/` | Backend needs connection target |
| 12 | `10-load-balancer/` | Needs healthy frontend targets |
| 13 | `13-monitoring-logging/` | Operate running stack |

## Cost gates (read before creating)

Stop and read [../docs/cost.md](../docs/cost.md) before:

- Creating an **Application Load Balancer**
- Creating **RDS** (Free Tier eligible but not “free forever”)
- Allocating **Elastic IPs** you leave unattached

NAT Gateway is **not** in the default path.

## Documentation template

Each step file will follow:

`Objective → Why → Architecture → Prerequisites → AWS Configuration → CLI → Validation → Troubleshooting → Cleanup → What’s Next`

## What comes next?

Wait for Phase B implementation, or start with prerequisites you control today:

```bash
aws sts get-caller-identity
aws configure get region
curl -s https://checkip.amazonaws.com
```

Save your IP as `MY_IP/32` for VPN and Squid SSH rules.
