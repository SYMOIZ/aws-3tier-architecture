# Deploy — Friend architecture (checklist)

Architecture = your diagram: **Public** (ALB + Squid + OpenVPN) → **Private** (Frontend + Backend).

## Diagram

![Architecture diagram](architecture/friend-diagram.jpg)

SVG version: [`architecture/diagram.svg`](architecture/diagram.svg)

```text
INTERNET
   │
   ├─► ALB :80 (APP-SG, Anywhere) ──► Frontend :80 (Web-SG)
   │                              ──► Backend  :8000 (Backend-SG)
   ├─► OpenVPN :1194 (VPN-SG, MyIP) ──► SSH :22 (Connect-SG)
   └─► Squid :8888 (Proxy-SG) ◄── Frontend + Backend (outbound)
```

**Region:** `ap-south-1` · **Ubuntu 24.04** · **t3.micro** · Tag: `Project=3tier`

| Host | Subnet | IP | Security groups |
|------|--------|-----|-----------------|
| Squid | public-a `10.0.1.0/24` | `10.0.1.10` | Remote-SG + Proxy-SG |
| OpenVPN | public-a | `10.0.1.20` + EIP | VPN-SG + Remote-SG |
| Frontend | private-a `10.0.11.0/24` | `10.0.11.10` | Web-SG + Connect-SG |
| Backend | private-a | `10.0.11.20` | Backend-SG + Connect-SG |
| ALB | public-a + public-b | AWS | APP-SG |

Also: public-b `10.0.2.0/24`, private-b `10.0.12.0/24` (ALB needs 2 AZs).

**COST:** ALB is paid → finish with Step 9.

---

## Master checklist

- [ ] Step 1 — VPC
- [ ] Step 2 — Security groups
- [ ] Step 3 — Key pair
- [ ] Step 4 — Squid
- [ ] Step 5 — OpenVPN + client `.ovpn`
- [ ] Step 6 — Frontend + Backend
- [ ] Step 7 — ALB
- [ ] Step 8 — Test all boxes below
- [ ] Step 9 — Cleanup (when finished)

---

## Step 1 — VPC

- [ ] VPC `3tier-vpc` = `10.0.0.0/16`, DNS hostnames ON
- [ ] Subnet `3tier-public-a` AZ-a `10.0.1.0/24` + auto-assign public IP
- [ ] Subnet `3tier-public-b` AZ-b `10.0.2.0/24` + auto-assign public IP
- [ ] Subnet `3tier-private-a` AZ-a `10.0.11.0/24`
- [ ] Subnet `3tier-private-b` AZ-b `10.0.12.0/24`
- [ ] IGW `3tier-igw` attached
- [ ] Public RT: `0.0.0.0/0` → IGW → both public subnets
- [ ] Private RT: **local only** (no NAT) → both private subnets

---

## Step 2 — Security groups

Create all empty first, then rules:

- [ ] `APP-SG` — TCP 80 from `0.0.0.0/0`
- [ ] `Web-SG` — TCP 80 from APP-SG
- [ ] `Backend-SG` — TCP 8000 from APP-SG
- [ ] `Proxy-SG` — TCP 8888 from Web-SG **and** Backend-SG
- [ ] `Remote-SG` — TCP 22 from **My IP**
- [ ] `VPN-SG` — UDP 1194 from **My IP**
- [ ] `Connect-SG` — TCP 22 from VPN-SG

---

## Step 3 — Key pair

- [ ] Created `3tier-key` (ED25519, `.pem`)
- [ ] File saved safely on PC

---

## Step 4 — Squid

Paste [`userdata/squid.sh`](userdata/squid.sh) into User data.

- [ ] Instance `squid-proxy` in `3tier-public-a`
- [ ] Primary IP `10.0.1.10`, public IP ON
- [ ] SG = Remote-SG + Proxy-SG
- [ ] SSH works from MyIP
- [ ] `sudo systemctl status squid` = active
- [ ] Port 8888 listening

---

## Step 5 — OpenVPN

Paste [`userdata/openvpn.sh`](userdata/openvpn.sh) into User data.

- [ ] Instance `openvpn-server` IP `10.0.1.20`
- [ ] SG = VPN-SG + Remote-SG
- [ ] Source/dest check **stopped**
- [ ] Elastic IP associated
- [ ] `sudo make-client my-pc <EIP>` done
- [ ] `my-pc.ovpn` copied to PC
- [ ] OpenVPN Connect succeeds

---

## Step 6 — Frontend + Backend

Before paste: `__SQUID_IP__` → `10.0.1.10`, `__PROXY_PORT__` → `8888`.

- [ ] `frontend` — `10.0.11.10`, Web-SG + Connect-SG, **no public IP**, userdata [`frontend.sh`](userdata/frontend.sh)
- [ ] `backend` — `10.0.11.20`, Backend-SG + Connect-SG, **no public IP**, userdata [`backend.sh`](userdata/backend.sh)
- [ ] VPN connected → SSH `ubuntu@10.0.11.10` works
- [ ] VPN connected → SSH `ubuntu@10.0.11.20` works

---

## Step 7 — ALB (paid)

- [ ] TG `3tier-frontend-tg` HTTP 80, health `/`, frontend registered
- [ ] TG `3tier-backend-tg` HTTP 8000, health `/api/health`, backend registered
- [ ] ALB `3tier-alb` internet-facing, public-a + public-b, SG = **APP-SG only**
- [ ] Listener :80 default → frontend-tg
- [ ] Rule priority 10: path `/api/*` → backend-tg
- [ ] Both targets **Healthy**

---

## Step 8 — Test checklist

- [ ] `http://<ALB-DNS>` shows Frontend page + Backend JSON
- [ ] `http://<ALB-DNS>/api/health` → `{"status":"ok"}`
- [ ] Frontend/Backend have **empty** Public IPv4
- [ ] On private host: `curl https://ubuntu.com` works (via Squid)
- [ ] On private host: direct internet without proxy fails/times out
- [ ] SSH to private hosts only works while VPN is connected

---

## Step 9 — Cleanup / reset checklist

- [ ] Delete ALB
- [ ] Delete both target groups
- [ ] Terminate Squid, OpenVPN, Frontend, Backend
- [ ] Release Elastic IP
- [ ] Delete all 7 security groups
- [ ] Delete 4 subnets
- [ ] Delete 2 route tables
- [ ] Detach + delete IGW
- [ ] Delete VPC
- [ ] Delete key pair (optional)

---

## Optional CLI (same checklist order)

```bash
cd scripts
bash 01-network.sh && bash 02-security-groups.sh && bash 03-keypair-ami.sh \
  && bash 04-squid.sh && bash 05-openvpn.sh && bash 06-app-servers.sh && bash 07-alb.sh
```

Teardown: `bash 99-teardown.sh`
