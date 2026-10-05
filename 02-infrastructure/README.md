# Part 02 — Build AWS Infrastructure (SOP phases)

Follow this order. Do not skip validation between major steps.

| Phase | Script / action | Why |
|-------|-----------------|-----|
| 1 | IAM + Resource Group ([01-iam/](01-iam/)) | Least-privilege deployer before infra |
| 2 | [scripts/01-network.sh](../scripts/01-network.sh) | VPC/subnets/IGW/routes |
| 3 | [scripts/02-security-groups.sh](../scripts/02-security-groups.sh) | Seven SGs from the matrix |
| 4 | [scripts/03-keypair-ami.sh](../scripts/03-keypair-ami.sh) | ED25519 key + Ubuntu 24.04 AMI |
| 5 | [scripts/04-squid.sh](../scripts/04-squid.sh) | Egress proxy **before** private apps |
| 6 | [scripts/05-openvpn.sh](../scripts/05-openvpn.sh) | Admin path into private subnet |
| 7 | [scripts/06-app-servers.sh](../scripts/06-app-servers.sh) | Frontend + Backend (need Squid) |
| 8 | [scripts/07-alb.sh](../scripts/07-alb.sh) | Public entry; needs healthy targets |
| 9 | Client `.ovpn` + connect | SSH to private IPs |
| — | [scripts/99-teardown.sh](../scripts/99-teardown.sh) | Stop charges |

## Prerequisites

- AWS CLI v2, Git Bash (Windows) or WSL
- Admin/root for Phase 1 only, then use `3tier-deployer`
- Working directory: `scripts/` (creates `ids.sh` and `3tier-key.pem`)

```bash
cd scripts
source ./vars.sh
echo "$MY_IP"
aws sts get-caller-identity
```

## Cost gates

Before Phase 8 (ALB): ALB is **not** Free Tier — see [../docs/cost.md](../docs/cost.md).  
Elastic IP is free while attached to a running instance; release on teardown.
