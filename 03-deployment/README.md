# Part 03 — Deploy and Configure the Application

## Objective

Install and configure software **after** Part 02 infrastructure exists.

## Planned contents

| Folder | Contents |
|--------|----------|
| `frontend/` | nginx, static build, reverse proxy to backend |
| `backend/` | API service, env vars, systemd unit, health `/health` |
| `database/` | Schema migrations, connection string from backend only |
| `vpn/` | Client `.ovpn` generation (gitignored templates only) |
| `monitoring/` | CloudWatch agent basics |

## Dependency

Do not deploy applications until:

- Frontend/backend EC2 pass SSH via VPN
- Backend reaches database on 5432
- Squid proxy works from private instances (`curl -x http://squid:8888 https://example.com`)

## What comes next?

Wait for Part 02 EC2 and database steps, then follow subfolders as they are added.
