# Secure AWS 3-Tier Architecture

Learning-first AWS lab you deploy **by hand in the AWS Console** (not Terraform): Application Load Balancer, **Squid** forward proxy, **OpenVPN**, private Frontend (Nginx) and Backend (Python API). No NAT Gateway.

Based on the SOP: *AWS 3-Tier Architecture with Squid Proxy & OpenVPN* (Syed Faizan Jafri, Oct 2026).

## Important: how you deploy

| Method | Status |
|--------|--------|
| **AWS Console (manual)** | **Primary — use this** |
| Bash scripts in `scripts/` | Optional helper only |
| Terraform | **Not used** (none in this repo) |

Start here: **[02-infrastructure/README.md](02-infrastructure/README.md)**

## What we are building

```text
Internet
   │
   ├─► ALB :80  ──default──► Frontend :80   (10.0.11.10)
   │            ──/api/*───► Backend  :8000 (10.0.11.20)
   │
   └─► OpenVPN :1194 (MyIP) ──tunnel──► SSH to Frontend/Backend

Frontend / Backend ──► Squid :8888 ──► Internet (outbound only)
```

| Component | Subnet | Private IP | Security groups |
|-----------|--------|------------|-----------------|
| ALB | public-a + public-b | AWS-managed | APP-SG |
| Squid | public-a | 10.0.1.10 | Remote-SG, Proxy-SG |
| OpenVPN | public-a | 10.0.1.20 (+ EIP) | VPN-SG, Remote-SG |
| Frontend | private-a | 10.0.11.10 | Web-SG, Connect-SG |
| Backend | private-a | 10.0.11.20 | Backend-SG, Connect-SG |

**Region:** `ap-south-1` · **OS:** Ubuntu 24.04 · **Size:** `t3.micro`

## Hand deployment order

1. [Understand concepts](01-understand/)
2. [IAM](02-infrastructure/01-iam/)
3. [VPC](02-infrastructure/02-vpc/)
4. [Security groups](02-infrastructure/03-security-groups/)
5. [Squid](02-infrastructure/04-squid/) (paste [userdata/squid.sh](userdata/squid.sh))
6. [OpenVPN](02-infrastructure/05-openvpn/) (paste [userdata/openvpn.sh](userdata/openvpn.sh))
7. [Frontend + Backend](02-infrastructure/06-app-servers/)
8. [Load Balancer](02-infrastructure/07-load-balancer/) — **paid service**
9. [VPN client + SSH](03-deployment/vpn-client.md)
10. [Test](04-operations/testing/) · [Troubleshoot](04-operations/troubleshooting/) · [Cleanup](04-operations/cleanup/)

**Cost warning:** ALB and idle Elastic IPs bill money. Delete when finished. [docs/cost.md](docs/cost.md)

## Repository map

| Path | Purpose |
|------|---------|
| [01-understand/](01-understand/) | Concepts |
| [02-infrastructure/](02-infrastructure/) | **Console step-by-step phases** |
| [03-deployment/](03-deployment/) | VPN client + app notes |
| [04-operations/](04-operations/) | Test, troubleshoot, cleanup |
| [userdata/](userdata/) | Paste into EC2 User data |
| [iam/policies/](iam/policies/) | Policy JSON for Phase 1 |
| [scripts/](scripts/) | Optional CLI only — not required |
| [architecture/](architecture/) | Network + SG matrix |

## Go-live checklist

- [ ] `http://<ALB_DNS>` shows Frontend + Backend JSON
- [ ] `http://<ALB_DNS>/api/health` → `{"status":"ok"}`
- [ ] Both target groups healthy
- [ ] Frontend/Backend have **no** public IP
- [ ] Via Squid works; direct internet from private hosts times out
- [ ] OpenVPN + SSH to `10.0.11.10` / `10.0.11.20` while connected
