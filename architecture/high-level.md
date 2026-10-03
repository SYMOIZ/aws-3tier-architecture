# High-Level Architecture

## Layers

| Layer | Components |
|-------|------------|
| Public | ALB, OpenVPN EC2, Squid EC2 |
| Private application | Frontend EC2, Backend EC2 |
| Private data | RDS PostgreSQL (default) or PostgreSQL on EC2 |

## Design decisions

1. **Backend not on ALB** — Preserves classic 3-tier teaching flow; frontend proxies API calls internally.
2. **Squid not NAT** — Lower monthly cost for labs; requires proxy env on instances.
3. **Single AZ first** — Cheaper; HA documented as follow-up.
4. **OpenVPN in public subnet** — Needs UDP 1194 from your IP; pushes routes to private CIDRs.

## Comparison to original friend diagram

| Friend diagram | This repo |
|----------------|-----------|
| ALB → Frontend and ALB → Backend | ALB → Frontend only; Frontend → Backend |
| No database tier | Private DB tier added |
| APP-SG on LB | Renamed ALB-SG |
| WEB-SG / Proxy-SG pattern | Kept, documented in SG matrix |

See [security-group-matrix.md](security-group-matrix.md) and [network.md](network.md).
