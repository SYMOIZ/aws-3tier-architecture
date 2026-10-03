# AWS Components Used in This Project

## Objective

Map each AWS service to a plain-English role in NexusOps.

## IAM (Identity and Access Management)

Controls **who** can call AWS APIs (users, roles) and **what** they can do (policies).

| Concept | Purpose |
|---------|---------|
| IAM User | Human or break-glass operator |
| IAM Group | Collection of users with shared policies |
| IAM Policy | JSON document of Allow/Deny actions |
| IAM Role | Assumed by services or EC2 (no long-lived password) |
| Instance profile | Container that attaches a role to an EC2 instance |

**Least privilege:** deployment users get scoped policies in [../iam/](../iam/)—not standing `AdministratorAccess` in production.

## Security group

Stateful virtual firewall on an ENI. Rules are **allow only**; default deny inbound.

## EC2 instance

Virtual server. Frontend/backend/VPN/Squid run on EC2 in this lab design.

## Load balancer (ALB)

Distributes HTTP traffic to healthy targets in a **target group**. Health checks remove failed frontend instances.

## VPN

Encrypted tunnel from your laptop into the VPC. Administrators reach private IPs without exposing SSH to the whole internet.

## OpenVPN

Open-source VPN software. Server listens on **UDP 1194** (common default). Clients receive routes to private CIDRs.

## Forward proxy

An intermediary for **outbound** requests. Private servers send HTTP CONNECT/GET to the proxy; the proxy fetches from the internet.

## Squid

Widely used caching forward proxy. Here we use it primarily for **controlled egress** and package installs—not heavy caching.

## Why Squid instead of NAT Gateway?

| Option | Pros | Cons |
|--------|------|------|
| NAT Gateway | Simple default route | **~$32+/month + data processing** |
| Squid on t3.micro | Low cost for labs | You must configure proxy on instances |

## How components connect (summary)

See [traffic-flow.md](traffic-flow.md) and [../architecture/security-group-matrix.md](../architecture/security-group-matrix.md).

## What comes next?

[traffic-flow.md](traffic-flow.md)
