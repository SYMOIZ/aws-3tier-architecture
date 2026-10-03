# Network Design

## VPC CIDR

`10.0.0.0/16` — 65,536 addresses; split into /24 subnets.

## Subnets (single-AZ lab)

| Name | CIDR | Type |
|------|------|------|
| public-subnet-a | 10.0.1.0/24 | Public |
| private-app-a | 10.0.10.0/24 | Private |
| private-db-a | 10.0.20.0/24 | Private |

## Routing

**Public route table**

- `10.0.0.0/16` → local
- `0.0.0.0/0` → Internet Gateway

**Private route tables**

- `10.0.0.0/16` → local only (no 0.0.0.0/0 to NAT in default design)

## DNS

Enable `enableDnsHostnames` and `enableDnsSupport` on the VPC for RDS endpoints and internal hostnames.

## OpenVPN routing

Push route `10.0.0.0/16` (or specific private subnets) to clients so administrators reach `10.0.10.x` and `10.0.20.x`.

## Upgrade path (2 AZ)

Duplicate `private-app-b` and `private-db-b` in a second AZ; add second public subnet for ALB requirement (ALB needs ≥2 AZs in production—**for minimal lab, single AZ ALB is possible in some regions but not best practice**). Document ALB multi-AZ when expanding.
