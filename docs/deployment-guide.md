# Deployment Guide — Console first

**Deploy by hand in the AWS Console.** This repo has **no Terraform**.

## Phase 0 — Read (no charges)

1. [../README.md](../README.md)
2. [../01-understand/](../01-understand/)
3. [cost.md](cost.md) — set a billing alarm

## Phase 1–9 — Console guides

Follow [../02-infrastructure/README.md](../02-infrastructure/README.md) in order.

When launching EC2, paste files from [../userdata/](../userdata/).  
For Frontend/Backend, replace `__SQUID_IP__` with `10.0.1.10` and `__PROXY_PORT__` with `8888` before paste.

## Phase 9 — VPN

[../03-deployment/vpn-client.md](../03-deployment/vpn-client.md)

## Cleanup

[../04-operations/cleanup/README.md](../04-operations/cleanup/README.md) — delete ALB first, then instances, EIP, SGs, VPC.

## Optional scripts

Only if you choose automation later: [../scripts/README.md](../scripts/README.md). Still not Terraform.
