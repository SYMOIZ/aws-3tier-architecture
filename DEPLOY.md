# Deploy — Friend architecture only (no extra steps)

This is the **only** deploy guide you need.  
Architecture = your diagram: **Public** (ALB + Squid + OpenVPN) → **Private** (Frontend + Backend).

```text
INTERNET
   │
   ├─► ALB :80 (APP-SG, Anywhere) ──► Frontend :80 (Web-SG)
   │                              ──► Backend  :8000 (Backend-SG)
   ├─► OpenVPN :1194 (VPN-SG, MyIP) ──► SSH :22 (Connect-SG)
   └─► Squid :8888 (Proxy-SG) ◄── Frontend + Backend (outbound)
```

**Region:** `ap-south-1` · **Ubuntu 24.04** · **t3.micro**  
**Tag everything:** `Project=3tier`

| Host | Subnet | IP | Security groups |
|------|--------|-----|-----------------|
| Squid | public-a `10.0.1.0/24` | `10.0.1.10` | Remote-SG + Proxy-SG |
| OpenVPN | public-a | `10.0.1.20` + EIP | VPN-SG + Remote-SG |
| Frontend | private-a `10.0.11.0/24` | `10.0.11.10` | Web-SG + Connect-SG |
| Backend | private-a | `10.0.11.20` | Backend-SG + Connect-SG |
| ALB | public-a + public-b | AWS | APP-SG |

Also create: public-b `10.0.2.0/24`, private-b `10.0.12.0/24` (ALB needs 2 AZs).

**COST:** ALB is paid. Delete when done (Step 9).

---

## Step 1 — VPC (Console → VPC)

1. Create VPC `3tier-vpc` CIDR `10.0.0.0/16` → enable DNS hostnames  
2. Subnets:  
   - `3tier-public-a` AZ-a `10.0.1.0/24` → enable auto-assign public IP  
   - `3tier-public-b` AZ-b `10.0.2.0/24` → enable auto-assign public IP  
   - `3tier-private-a` AZ-a `10.0.11.0/24`  
   - `3tier-private-b` AZ-b `10.0.12.0/24`  
3. IGW `3tier-igw` → attach to VPC  
4. Route table `3tier-public-rt`: `0.0.0.0/0` → IGW → associate both public subnets  
5. Route table `3tier-private-rt`: **local only** (no NAT) → associate both private subnets  

---

## Step 2 — Security groups (create all empty, then add rules)

| Name | Inbound |
|------|---------|
| APP-SG | TCP 80 from `0.0.0.0/0` |
| Web-SG | TCP 80 from APP-SG |
| Backend-SG | TCP 8000 from APP-SG |
| Proxy-SG | TCP 8888 from Web-SG **and** Backend-SG |
| Remote-SG | TCP 22 from **My IP** |
| VPN-SG | UDP 1194 from **My IP** |
| Connect-SG | TCP 22 from VPN-SG |

Outbound = default allow all.

---

## Step 3 — Key pair

EC2 → Key pairs → Create `3tier-key` (ED25519, `.pem`) → save file.

---

## Step 4 — Squid (must be before Frontend/Backend)

Launch instance:

- Name `squid-proxy`, Ubuntu 24.04, t3.micro, key `3tier-key`  
- Subnet `3tier-public-a`, public IP **Enable**, primary IP `10.0.1.10`  
- SG: Remote-SG + Proxy-SG  
- User data = paste full file [`userdata/squid.sh`](userdata/squid.sh)  

Check: SSH `ubuntu@<public-ip>` → `sudo systemctl status squid`

---

## Step 5 — OpenVPN

Launch:

- Name `openvpn-server`, same AMI/type/key  
- Subnet `3tier-public-a`, primary IP `10.0.1.20`  
- SG: VPN-SG + Remote-SG  
- User data = paste [`userdata/openvpn.sh`](userdata/openvpn.sh)  

Then:

1. Actions → Networking → **Stop source/destination check**  
2. Allocate Elastic IP → Associate to this instance  
3. SSH → `sudo make-client my-pc <EIP>` → `scp` the `.ovpn` to your PC  
4. Connect with OpenVPN Connect app  

---

## Step 6 — Frontend + Backend (no public IP)

**Edit before paste:** in both userdata files set `__SQUID_IP__` = `10.0.1.10`, `__PROXY_PORT__` = `8888`.

| Name | IP | SG | User data |
|------|-----|-----|-----------|
| frontend | 10.0.11.10 | Web-SG + Connect-SG | [`userdata/frontend.sh`](userdata/frontend.sh) |
| backend | 10.0.11.20 | Backend-SG + Connect-SG | [`userdata/backend.sh`](userdata/backend.sh) |

Subnet = `3tier-private-a`, auto-assign public IP = **Disable**.

SSH only after VPN connected:  
`ssh -i 3tier-key.pem ubuntu@10.0.11.10`

---

## Step 7 — ALB (paid)

1. Target group `3tier-frontend-tg` HTTP 80, health `/`, register frontend  
2. Target group `3tier-backend-tg` HTTP 8000, health `/api/health`, register backend  
3. ALB `3tier-alb` internet-facing, subnets public-a + public-b, SG = **APP-SG only**  
4. Listener :80 → default forward frontend-tg  
5. Rule priority 10: path `/api/*` → backend-tg  

Open `http://<ALB-DNS>` — done.

---

## Step 8 — Test (1 minute)

- Browser: ALB URL shows Frontend + Backend JSON  
- `http://<ALB-DNS>/api/health` → `{"status":"ok"}`  
- VPN on → SSH to `10.0.11.10` / `10.0.11.20`  
- On private host: `curl https://ubuntu.com` works (via Squid); without proxy it fails  

---

## Step 9 — Cleanup / reset (same place)

Delete in order:

1. ALB  
2. Both target groups  
3. Terminate 4 instances  
4. Release Elastic IP  
5. Delete 7 security groups  
6. Delete 4 subnets → 2 route tables → detach/delete IGW → delete VPC  
7. Delete key pair (optional)  

---

## Optional: one-command CLI (same architecture)

Only if you prefer scripts instead of Console:

```bash
cd scripts
bash 01-network.sh && bash 02-security-groups.sh && bash 03-keypair-ami.sh \
  && bash 04-squid.sh && bash 05-openvpn.sh && bash 06-app-servers.sh && bash 07-alb.sh
```

Teardown: `bash 99-teardown.sh`
