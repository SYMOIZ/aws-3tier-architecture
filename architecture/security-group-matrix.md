# Security Group Matrix (SOP)

Outbound rules stay at the default (all traffic allowed) for every group.  
`MyIP` = your current public IP with `/32`. If it changes, run `scripts/update-my-ip.sh`.

## Inbound rules

| Security group | Attached to | Protocol / port | Source | Why |
|----------------|-------------|-----------------|--------|-----|
| APP-SG | ALB | TCP 80 | 0.0.0.0/0 | Public web traffic |
| Web-SG | Frontend | TCP 80 | APP-SG | Only the ALB may reach the web UI |
| Backend-SG | Backend | TCP 8000 | APP-SG | Only the ALB may reach the API |
| Proxy-SG | Squid | TCP 8888 | Web-SG **and** Backend-SG | Private servers use the proxy |
| Remote-SG | Squid, OpenVPN | TCP 22 | MyIP/32 | You administer public servers |
| VPN-SG | OpenVPN | UDP 1194 | MyIP/32 | Your OpenVPN client connects |
| Connect-SG | Frontend, Backend | TCP 22 | VPN-SG | SSH only from inside the VPN |

**SOP fix vs diagram gap:** Proxy-SG must allow **Backend-SG** as well as Web-SG, or Backend cannot install packages through Squid.

## Why Connect-SG works with VPN-SG

The OpenVPN server NATs tunnel traffic to its own private IP. Packets to Frontend/Backend therefore come from an instance that carries **VPN-SG**, so the Connect-SG rule matches.
