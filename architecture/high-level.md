# High-Level Architecture (SOP)

## Layers

| Layer | Components |
|-------|------------|
| Public | ALB (APP-SG), Squid (Remote-SG + Proxy-SG), OpenVPN (VPN-SG + Remote-SG) |
| Private | Frontend Nginx :80 (Web-SG + Connect-SG), Backend API :8000 (Backend-SG + Connect-SG) |

## Traffic

1. **Users** → ALB :80 → Frontend (default) and Backend `/api/*` (path rule).
2. **Frontend / Backend** → Squid :8888 → Internet (apt, pip, git, HTTPS).
3. **Your PC** → OpenVPN UDP 1194 (MyIP) → SSH :22 via Connect-SG.
4. **Your PC** → Squid / VPN SSH :22 (MyIP) via Remote-SG.

## Design choices from the SOP

- No NAT Gateway (cost + teaching egress control).
- No public IP on Frontend/Backend.
- Split-tunnel OpenVPN: push only `10.0.0.0/16`.
- Path-based ALB routing for a simple public API (`/api/*`).
