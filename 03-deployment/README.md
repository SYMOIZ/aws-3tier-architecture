# Part 03 — Deploy and Configure the Application

**VPN client (hand):** [vpn-client.md](vpn-client.md)

Sample apps are installed by **EC2 User data** (paste in Console) in Phase 7:

| Host | User-data | Service |
|------|-----------|---------|
| Frontend | [../userdata/frontend.sh](../userdata/frontend.sh) | Nginx + sample HTML calling `/api/info` |
| Backend | [../userdata/backend.sh](../userdata/backend.sh) | Python `ThreadingHTTPServer` on :8000 (`/api/health`, `/api/*`) |

Replace the sample page/API with your real application later; keep ports **80** / **8000**, proxy env, and systemd layout.

## VPN client profiles

Generated on the OpenVPN server with `sudo make-client <name> <EIP>`. Copy `.ovpn` to your PC; treat like a password (gitignored).
