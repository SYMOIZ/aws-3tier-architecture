# Architecture Traffic Flow (Reference)

Same content as [../01-understand/traffic-flow.md](../01-understand/traffic-flow.md), kept here for operators who jump straight to `architecture/`.

Primary paths:

1. **Web:** Internet → ALB → Frontend  
2. **API:** Frontend → Backend → Database  
3. **Admin:** Internet → VPN → SSH to private instances  
4. **Egress:** Frontend/Backend → Squid → Internet  
