# Cost Considerations

**Disclaimer:** AWS prices change by region and date. Verify in [AWS Pricing Calculator](https://calculator.aws/) and the [Free Tier page](https://aws.amazon.com/free/) before deploying.

## Categories

| Category | Service | Free Tier (typical new account) | Low-cost lab | Paid / watch |
|----------|---------|----------------------------------|--------------|--------------|
| Compute | EC2 t3.micro | 750 h/month × 12 months | ~$8–10/mo if over free | Larger instances |
| Database | RDS db.t3.micro PostgreSQL | 750 h, 20 GB × 12 months | ~$15+/mo after | Storage, backups |
| Load balancing | ALB | **Not Free Tier** | **~$16+/month + LCU** | Required for public HA entry |
| NAT | NAT Gateway | N/A | **Avoided** (Squid used) | ~$32+/mo + data if added |
| VPN | OpenVPN on EC2 | Uses EC2 free tier hours | Same as EC2 | Client VPN managed service separate |
| Proxy | Squid on EC2 | Uses EC2 free tier hours | Same as EC2 | — |
| IP | Elastic IP | Free when attached to running instance | Charge if **unattached** | — |
| Monitoring | CloudWatch | Basic metrics; logs billed | Logs/metrics volume | Custom dashboards |
| Data transfer | Various | 100 GB out/month often cited for free tier | Beyond allowance | Inter-AZ, to internet |

## Learning recommendations

1. **Stop instances** when not studying (RDS stop has limits—check docs).
2. **Run cleanup** ([../04-operations/cleanup/README.md](../04-operations/cleanup/README.md)) when finished.
3. **Set a billing alarm** in AWS Budgets before Part 02 deploy.
4. Read the **ALB cost gate** in [../02-infrastructure/README.md](../02-infrastructure/README.md) before creating the load balancer.

## Squid vs NAT (cost trade-off)

Squid adds operational steps (proxy env on hosts) but avoids NAT Gateway hourly and processing charges—appropriate for this educational project.
