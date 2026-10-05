# Phase 7 — Frontend and Backend (Console)

## Objective

Launch private Nginx (Frontend) and Python API (Backend) with **no public IP**. Start only after Squid is healthy.

## Prepare user data

Open the files and replace placeholders **before** pasting into the console:

| File | Replace |
|------|---------|
| [../../userdata/frontend.sh](../../userdata/frontend.sh) | `__SQUID_IP__` → `10.0.1.10`, `__PROXY_PORT__` → `8888` |
| [../../userdata/backend.sh](../../userdata/backend.sh) | same |

## Launch Frontend

| Setting | Value |
|---------|--------|
| Name | `frontend` |
| AMI | Ubuntu 24.04 |
| Type | `t3.micro` |
| Key | `3tier-key` |
| Subnet | `3tier-private-a` |
| Auto-assign public IP | **Disable** |
| Primary IP | `10.0.11.10` |
| Security groups | `Web-SG` **and** `Connect-SG` |
| User data | edited `frontend.sh` |
| Tags | `Name=frontend`, `Project=3tier` |

## Launch Backend

Same as Frontend, except:

| Setting | Value |
|---------|--------|
| Name | `backend` |
| Primary IP | `10.0.11.20` |
| Security groups | `Backend-SG` **and** `Connect-SG` |
| User data | edited `backend.sh` |

## Validation

- Public IPv4 column is **empty** for both.
- You **cannot** SSH yet until OpenVPN is connected (Phase 9).
- After VPN: `sudo tail -n 30 /var/log/cloud-init-output.log` on each host.

## What comes next?

[../07-load-balancer/](../07-load-balancer/)
