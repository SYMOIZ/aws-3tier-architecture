# Secure AWS 3-Tier (Squid + OpenVPN)

**Your friend diagram only.** No Terraform. No extra learning phases.

```text
INTERNET
   │
   ├── ALB :80 (APP-SG) ─────► Frontend :80  (Web-SG)
   │                      └──► Backend  :8000 (Backend-SG)
   ├── OpenVPN :1194 (VPN-SG, MyIP) ──► SSH :22 (Connect-SG)
   └── Squid :8888 (Proxy-SG) ◄── Frontend + Backend outbound
```

| Who | Entry |
|-----|--------|
| Users (browser) | **ALB** |
| Admin (you) | **OpenVPN** → SSH |
| Private servers need packages | **Squid** |

## Deploy

### → Open **[DEPLOY.md](DEPLOY.md)** ← only file you need

9 steps: VPC → SG → Key → Squid → OpenVPN → Apps → ALB → Test → Cleanup  

Paste boot scripts from [`userdata/`](userdata/) into EC2 User data.

## Cost

ALB is **paid**. Cleanup = Step 9 in `DEPLOY.md`.
