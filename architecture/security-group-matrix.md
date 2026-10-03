# Security Group Matrix

Replace `MY_IP/32` with your public IP. Replace `sg-xxx` references with IDs after creation.

## Inbound rules

| Source | Destination | Port | Protocol | Purpose |
|--------|-------------|------|----------|---------|
| 0.0.0.0/0 | ALB-SG | 80 | TCP | Public HTTP (lab; add 443 later) |
| MY_IP/32 | VPN-SG | 1194 | UDP | OpenVPN |
| MY_IP/32 | VPN-SG | 22 | TCP | Emergency SSH to VPN box (optional) |
| MY_IP/32 | PROXY-SG | 22 | TCP | SSH to Squid (admin) |
| ALB-SG | WEB-SG | 80 | TCP | LB to frontend |
| VPN-SG | CONNECT-SG | 22 | TCP | SSH to app servers via VPN |
| WEB-SG | BACKEND-SG | 8000 | TCP | Frontend to API |
| BACKEND-SG | DB-SG | 5432 | TCP | API to PostgreSQL |

## Outbound rules

Default: allow outbound as needed. Tighten in production:

| Source | Destination | Port | Purpose |
|--------|-------------|------|---------|
| WEB-SG | PROXY-SG | 8888 | Frontend egress via Squid |
| BACKEND-SG | PROXY-SG | 8888 | Backend egress via Squid |
| BACKEND-SG | DB-SG | 5432 | Database |
| PROXY-SG | 0.0.0.0/0 | 443,80 | Squid fetches internet |

## Not allowed (verify absent)

| Rule | Why bad |
|------|---------|
| 0.0.0.0/0 → BACKEND-SG:8000 | Exposes API |
| 0.0.0.0/0 → DB-SG:5432 | Exposes database |
| 0.0.0.0/0 → CONNECT-SG:22 | SSH from world |

## Friend diagram mapping

| Friend name | This repo |
|-------------|-----------|
| APP-SG (LB) | ALB-SG |
| Web-SG | WEB-SG |
| Backend-SG | BACKEND-SG |
| Proxy-SG | PROXY-SG |
| VPN-SG | VPN-SG |
| Connect-SG | CONNECT-SG |
| Remote-SG (SSH MyIP) | Merged into VPN/PROXY admin SSH rules |
