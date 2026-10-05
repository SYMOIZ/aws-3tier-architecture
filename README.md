# Secure AWS 3-Tier Architecture

Learning-first, **deployable** AWS lab: Application Load Balancer, **Squid** forward proxy, **OpenVPN**, private Frontend (Nginx) and Backend (Python API). No NAT Gateway — private servers reach the internet only through Squid; you reach them only through OpenVPN.

Based on the SOP: *AWS 3-Tier Architecture with Squid Proxy & OpenVPN* (Syed Faizan Jafri, Oct 2026).

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

**Region example:** `ap-south-1` (Mumbai). **OS:** Ubuntu Server 24.04 LTS. **Size:** `t3.micro`.

## Quick start (Git Bash)

```bash
cd "/c/Users/symoi/Desktop/New folder/aws-3tier-architecture"

# 1) Read Part 01 concepts
# 2) Phase 1 IAM (console) — see 02-infrastructure/01-iam/
# 3) Deploy network → ALB:
cd scripts
bash 00-resource-group.sh   # optional after IAM
bash 01-network.sh && bash 02-security-groups.sh && bash 03-keypair-ami.sh \
  && bash 04-squid.sh && bash 05-openvpn.sh && bash 06-app-servers.sh && bash 07-alb.sh
```

**Cost warning:** ALB, Elastic IP (if idle), and public IPv4 are billed. Teardown with `bash 99-teardown.sh` when finished. Details: [docs/cost.md](docs/cost.md).

## Repository map

| Path | Purpose |
|------|---------|
| [01-understand/](01-understand/) | Concepts before AWS |
| [02-infrastructure/](02-infrastructure/) | Phase guide matching the SOP |
| [03-deployment/](03-deployment/) | App / VPN client notes |
| [04-operations/](04-operations/) | Test, troubleshoot, teardown |
| [scripts/](scripts/) | `vars.sh` + `01`…`07` + teardown |
| [userdata/](userdata/) | Squid, OpenVPN, Frontend, Backend boot scripts |
| [iam/policies/](iam/policies/) | `3tier-deploy-policy.json` |
| [architecture/](architecture/) | Network + SG matrix |
| [docs/](docs/) | Cost, security, deployment guide |

## Learn first

1. [01-understand/what-is-3-tier.md](01-understand/what-is-3-tier.md)
2. [architecture/security-group-matrix.md](architecture/security-group-matrix.md)
3. [02-infrastructure/README.md](02-infrastructure/README.md) — run order
4. [docs/deployment-guide.md](docs/deployment-guide.md)

## Go-live checklist

- [ ] `http://<ALB_DNS>` shows Frontend and Backend JSON
- [ ] `http://<ALB_DNS>/api/health` → `{"status":"ok"}`
- [ ] Both target groups healthy
- [ ] Frontend/Backend have **no** public IP
- [ ] From private host: `curl` via Squid works; `--noproxy '*'` times out
- [ ] OpenVPN + SSH to `10.0.11.10` / `10.0.11.20` works only while connected

## Source SOP

Place a copy of the PDF next to this repo or keep it in Downloads. This repository encodes the same phases, IP plan, security groups, scripts, and userdata.
