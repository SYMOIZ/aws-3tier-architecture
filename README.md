# Secure AWS 3-Tier (Squid + OpenVPN)

**Deploy this diagram only.** No Terraform. No extra phases.

![Architecture](architecture/friend-diagram.jpg)

```text
INTERNET
   │
   ├── ALB :80 ──────────► Frontend :80
   │                 └──► Backend  :8000
   ├── OpenVPN :1194 ────► SSH private servers (admin)
   └── Squid :8888 ◄────── Frontend + Backend (outbound packages)
```

| Who | Entry |
|-----|--------|
| Users (browser) | **ALB** |
| Admin (you) | **OpenVPN** → SSH |
| Private servers need internet | **Squid** (not NAT) |

## Deploy

### → Open **[DEPLOY.md](DEPLOY.md)** ← only file you need

9 steps: VPC → SG → Key → Squid → OpenVPN → Apps → ALB → Test → Cleanup

Boot scripts to paste in EC2 User data: [`userdata/`](userdata/)

## Cost

ALB is **paid**. Cleanup = Step 9 in `DEPLOY.md`.
