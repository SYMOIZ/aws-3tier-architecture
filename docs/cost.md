# Cost Considerations

**Verify** current Free Tier and Pricing Calculator for your region before deploy.

| Service | Notes |
|---------|--------|
| EC2 t3.micro ×4 (Squid, VPN, FE, BE) | Often Free Tier eligible (750 h / 12 mo) |
| **Application Load Balancer** | **Paid** (~$16+/mo + LCU) — not Free Tier |
| Elastic IP | Free while attached to **running** instance; charged if idle |
| Public IPv4 | May have hourly charges depending on AWS public IPv4 pricing |
| NAT Gateway | **Not used** (Squid instead) — avoids ~$32+/mo |
| Data transfer | Variable |

**Teardown:** `bash scripts/99-teardown.sh` when finished. Set a billing alarm first.
