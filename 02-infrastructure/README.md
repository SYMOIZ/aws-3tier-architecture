# Part 02 — Build by hand (AWS Console)

**Primary path: AWS Console.** No Terraform.  
**Full context (Squid, where code runs, end-to-end flow):** see the **[root README](../README.md)** first.

| Phase | Folder | What you create | Related code |
|-------|--------|-----------------|--------------|
| 1 | [01-iam/](01-iam/) | IAM policy/group/user | Paste `iam/policies/3tier-deploy-policy.json` |
| 2 | [02-vpc/](02-vpc/) | VPC, subnets, IGW, routes | Console only |
| 3 | [03-security-groups/](03-security-groups/) | Seven SGs | Console only |
| 4–5 | [04-squid/](04-squid/) | Key + Squid EC2 | Paste `userdata/squid.sh` into User data |
| 6 | [05-openvpn/](05-openvpn/) | OpenVPN + EIP | Paste `userdata/openvpn.sh` |
| 7 | [06-app-servers/](06-app-servers/) | Frontend + Backend | Paste edited `userdata/frontend.sh` + `backend.sh` |
| 8 | [07-load-balancer/](07-load-balancer/) | ALB (paid) | Console only |
| 9 | [../03-deployment/vpn-client.md](../03-deployment/vpn-client.md) | VPN on your PC | `.ovpn` + SSH |
| Reset | [../04-operations/cleanup/](../04-operations/cleanup/) | Delete all | All teardown steps in that one folder |

## Fixed values

| Item | Value |
|------|--------|
| Region | `ap-south-1` |
| VPC | `10.0.0.0/16` |
| Squid / VPN / FE / BE | `10.0.1.10` / `10.0.1.20` / `10.0.11.10` / `10.0.11.20` |
| Tag | `Project=3tier` |

**Optional CLI:** [`../scripts/`](../scripts/) — not required for hand deploy.
