# Public vs Private Infrastructure

## Objective

Explain VPC building blocks before you create them in AWS.

## VPC (Virtual Private Cloud)

Your isolated network in AWS. You choose a **CIDR** (e.g. `10.0.0.0/16`). All subnets must fit inside this range.

**Why `10.0.0.0/16` for this lab?** Private RFC1918 space, room for many subnets, no overlap with common home `192.168.0.0/24` if you VPN in.

## Availability Zone (AZ)

A physically separate datacenter campus within a region. For high availability you duplicate subnets across AZs. **Learning default:** start with **one AZ** to reduce cost; document 2-AZ as an upgrade.

## Public subnet

A subnet whose route table has `0.0.0.0/0 → Internet Gateway`. Resources *can* receive traffic from the internet if security groups allow it.

## Private subnet

No direct route to the IGW. Instances typically have **no public IP**. Outbound internet in this project uses **Squid** in a public subnet (not NAT Gateway by default).

## Internet Gateway (IGW)

Attached to the VPC. Allows bidirectional internet routing for public subnets.

## Route table

List of destinations and next hops. Each subnet associates with **one** route table.

Example public route:

| Destination | Target |
|-------------|--------|
| 10.0.0.0/16 | local |
| 0.0.0.0/0 | igw-xxxxx |

Example private app route (Squid egress model):

| Destination | Target |
|-------------|--------|
| 10.0.0.0/16 | local |

Outbound HTTP(S) from private instances is configured to use proxy `10.0.1.x:8888` at the OS/app level—not a default route to NAT.

## Planned subnet layout (single AZ lab)

```text
VPC 10.0.0.0/16
└── AZ-a
    ├── public-subnet-a      10.0.1.0/24   ALB, VPN, Squid
    ├── private-app-a        10.0.10.0/24  Frontend, Backend
    └── private-db-a         10.0.20.0/24  PostgreSQL / RDS
```

## What comes next?

[aws-components.md](aws-components.md)
