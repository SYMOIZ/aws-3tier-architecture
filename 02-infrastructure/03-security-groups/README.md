# Phase 3 — Security groups (Console)

## Objective

Create seven security groups, then add inbound rules. Create **all groups first**, then rules (rules reference other groups).

## Console steps

### 1. Create empty groups

**EC2** → Security Groups → Create security group → VPC `3tier-vpc`.  
Create each with **no inbound rules yet**:

| Name | Description |
|------|-------------|
| `APP-SG` | ALB: HTTP 80 from anywhere |
| `Web-SG` | Frontend: 80 from APP-SG |
| `Backend-SG` | Backend: 8000 from APP-SG |
| `Proxy-SG` | Squid: 8888 from Web-SG and Backend-SG |
| `Remote-SG` | SSH 22 from my IP |
| `VPN-SG` | OpenVPN UDP 1194 from my IP |
| `Connect-SG` | SSH 22 from VPN-SG |

Tag: `Project=3tier`. Leave outbound as default (allow all).

### 2. Edit inbound rules

| Group | Type | Port | Source |
|-------|------|------|--------|
| APP-SG | HTTP | 80 | Anywhere-IPv4 (`0.0.0.0/0`) |
| Web-SG | HTTP | 80 | Security group → `APP-SG` |
| Backend-SG | Custom TCP | 8000 | Security group → `APP-SG` |
| Proxy-SG | Custom TCP | 8888 | `Web-SG` |
| Proxy-SG | Custom TCP | 8888 | `Backend-SG` (**required**) |
| Remote-SG | SSH | 22 | **My IP** |
| VPN-SG | Custom UDP | 1194 | **My IP** |
| Connect-SG | SSH | 22 | Security group → `VPN-SG` |

For My IP: use the Source dropdown **My IP** (or paste `YOUR.IP/32`).

## Validation

- Proxy-SG has **two** rules on 8888 (Web-SG and Backend-SG).
- Connect-SG source is VPN-SG, not `0.0.0.0/0`.
- No SSH from Anywhere on Frontend/Backend groups.

## What comes next?

[../04-squid/](../04-squid/)
