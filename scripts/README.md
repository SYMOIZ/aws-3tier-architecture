# Scripts (SOP)

Run from **Git Bash** inside this folder so `ids.sh` and relative userdata paths resolve.

```bash
cd "/c/Users/symoi/Desktop/New folder/aws-3tier-architecture/scripts"
```

| Script | Phase |
|--------|-------|
| [vars.sh](vars.sh) | Shared variables (sourced by others) |
| [00-resource-group.sh](00-resource-group.sh) | 1 — Resource Group after IAM |
| [01-network.sh](01-network.sh) | 2 — VPC / subnets / IGW / routes |
| [02-security-groups.sh](02-security-groups.sh) | 3 — Seven security groups |
| [03-keypair-ami.sh](03-keypair-ami.sh) | 4 — Key + Ubuntu AMI |
| [04-squid.sh](04-squid.sh) | 5 — Squid |
| [05-openvpn.sh](05-openvpn.sh) | 6 — OpenVPN + EIP |
| [06-app-servers.sh](06-app-servers.sh) | 7 — Frontend + Backend |
| [07-alb.sh](07-alb.sh) | 8 — ALB |
| [update-my-ip.sh](update-my-ip.sh) | Refresh MyIP on VPN/Remote SGs |
| [99-teardown.sh](99-teardown.sh) | Delete stack |
| [validation/check-prerequisites.sh](validation/check-prerequisites.sh) | Preflight |

**Do not commit:** `ids.sh`, `3tier-key.pem`, `*.ovpn` (gitignored).

Full chain after Phase 1 IAM:

```bash
bash 01-network.sh && bash 02-security-groups.sh && bash 03-keypair-ami.sh \
  && bash 04-squid.sh && bash 05-openvpn.sh && bash 06-app-servers.sh && bash 07-alb.sh
```
