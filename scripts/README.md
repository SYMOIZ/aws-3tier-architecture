# Scripts (OPTIONAL)

**You do not need these for the recommended path.**  
Primary deploy method = **AWS Console** — see [../02-infrastructure/README.md](../02-infrastructure/README.md).

These bash files automate the same SOP steps via AWS CLI. They are **not Terraform**.

| Script | Matches console phase |
|--------|------------------------|
| `vars.sh` | Shared values |
| `00-resource-group.sh` | Phase 1 Resource Group |
| `01-network.sh` | Phase 2 VPC |
| `02-security-groups.sh` | Phase 3 SGs |
| `03-keypair-ami.sh` | Phase 4 key |
| `04-squid.sh` | Phase 5 Squid |
| `05-openvpn.sh` | Phase 6 OpenVPN |
| `06-app-servers.sh` | Phase 7 apps |
| `07-alb.sh` | Phase 8 ALB |
| `update-my-ip.sh` | Refresh MyIP rules |
| `99-teardown.sh` | Cleanup |

If you use scripts, run them from Git Bash inside `scripts/` after IAM Phase 1.
