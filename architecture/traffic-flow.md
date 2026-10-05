# Architecture Traffic Flow (SOP)

1. **Web:** `Internet → ALB:80 → Frontend:80`
2. **API:** `Internet → ALB:80 /api/* → Backend:8000`
3. **Admin:** `Internet → OpenVPN:1194 → SSH Frontend/Backend:22`
4. **Egress:** `Frontend|Backend → Squid:8888 → Internet`
5. **Admin public boxes:** `MyIP → Squid|VPN:22`
