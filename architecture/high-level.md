# High-Level Architecture (SOP)

## Layers

| Layer | Components |
|-------|------------|
| Public | ALB (APP-SG), Squid (Remote-SG + Proxy-SG), OpenVPN (VPN-SG + Remote-SG) |
| Private | Frontend Nginx :80 (Web-SG + Connect-SG), Backend API :8000 (Backend-SG + Connect-SG) |

## Traffic

1. **Employees (users):** Internet → ALB :80 → Frontend `/` and Backend `/api/*` — **ALB is for the website, not for admin.**
2. **Admin:** Internet → OpenVPN :1194 → SSH — **no ALB.**
3. **Servers outbound:** Frontend/Backend → Squid :8888 → Internet (packages only).
4. **Admin SSH to Squid/VPN boxes:** MyIP → port 22 (Remote-SG).

## Design choices from the SOP

- No NAT Gateway (cost + teaching egress control).
- No public IP on Frontend/Backend.
- Split-tunnel OpenVPN: push only `10.0.0.0/16`.
- Path-based ALB routing for a simple public API (`/api/*`).
