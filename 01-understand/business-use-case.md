# Business Use Case — NexusOps Ltd.

## Objective

Anchor every technical decision to a realistic (but simple) company scenario.

## Company profile

**NexusOps Ltd.** is a regional company with a head office and branch offices. Employees use a web portal to:

- View operational dashboards
- Submit requests to the API
- Read data stored in PostgreSQL

Branch users connect over the public internet to the **load balancer**. IT administrators connect over **OpenVPN** to manage private servers.

## Requirements

| Requirement | Architecture response |
|-------------|------------------------|
| Public web access | Internet-facing Application Load Balancer |
| Private API | Backend in private subnet; no public IP |
| Private database | DB subnet; SG allows only backend |
| Controlled administration | OpenVPN + SSH from VPN security group only |
| Network segmentation | Public / private-app / private-db subnets |
| Secure outbound internet | Squid forward proxy (packages, patches) |
| Backup & monitoring | Part 04 (after core stack works) |
| Scalability path | Add AZs, ASG, RDS Multi-AZ later |

## Non-goals (for the first release)

- Multi-region disaster recovery
- Kubernetes
- Full SOC2 logging stack

## What comes next?

[public-vs-private.md](public-vs-private.md)
