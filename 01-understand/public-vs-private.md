# Public vs Private Infrastructure

## VPC

Isolated network: **`10.0.0.0/16`** (`3tier-vpc`).

## Availability Zones

ALB requires **two** public subnets (AZ a + AZ b). Servers in this SOP run in AZ a; private-b / public-b are ready for growth.

## Public subnet

Route: `0.0.0.0/0 → Internet Gateway`. Hosts: ALB, Squid (`10.0.1.10`), OpenVPN (`10.0.1.20`).

| Subnet | CIDR |
|--------|------|
| 3tier-public-a | 10.0.1.0/24 |
| 3tier-public-b | 10.0.2.0/24 |

## Private subnet

**No** `0.0.0.0/0` route. Outbound HTTP(S) only via Squid.

| Subnet | CIDR |
|--------|------|
| 3tier-private-a | 10.0.11.0/24 |
| 3tier-private-b | 10.0.12.0/24 |

## OpenVPN client pool

`10.8.0.0/24` — addresses on your laptop when connected. Server pushes route `10.0.0.0/16` (split tunnel).

## What comes next?

[aws-components.md](aws-components.md)
