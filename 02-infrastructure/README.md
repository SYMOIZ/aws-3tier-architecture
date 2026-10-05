# Part 02 — Build by hand (AWS Console)

**Primary path: AWS Management Console (click-by-click).**  
There is **no Terraform** in this project. Bash scripts under `scripts/` are optional shortcuts only.

| Phase | Guide | Create |
|-------|--------|--------|
| 1 | [01-iam/](01-iam/) | IAM policy, group, user, Resource Group |
| 2 | [02-vpc/](02-vpc/) | VPC, subnets, IGW, route tables |
| 3 | [03-security-groups/](03-security-groups/) | Seven security groups |
| 4–5 | [04-squid/](04-squid/) | Key pair + Squid EC2 |
| 6 | [05-openvpn/](05-openvpn/) | OpenVPN EC2 + Elastic IP |
| 7 | [06-app-servers/](06-app-servers/) | Frontend + Backend (private) |
| 8 | [07-load-balancer/](07-load-balancer/) | ALB + target groups |
| 9 | [../03-deployment/vpn-client.md](../03-deployment/vpn-client.md) | Connect OpenVPN + SSH |
| — | [../04-operations/cleanup/README.md](../04-operations/cleanup/README.md) | Delete resources by hand |

## Fixed values (use everywhere)

| Item | Value |
|------|--------|
| Region | `ap-south-1` (Mumbai) — or change consistently |
| VPC CIDR | `10.0.0.0/16` |
| Public A / B | `10.0.1.0/24` / `10.0.2.0/24` |
| Private A / B | `10.0.11.0/24` / `10.0.12.0/24` |
| Squid IP | `10.0.1.10` |
| VPN IP | `10.0.1.20` |
| Frontend IP | `10.0.11.10` |
| Backend IP | `10.0.11.20` |
| Instance type | `t3.micro` |
| AMI | Ubuntu Server 24.04 LTS |
| Tag on every resource | `Project` = `3tier` |

## Cost warning

ALB is **paid**. Tear down when done. See [../docs/cost.md](../docs/cost.md).

## Optional (not required)

If you later prefer CLI automation: [../scripts/README.md](../scripts/README.md). Still not Terraform.
