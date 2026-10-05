# Phase 2 — VPC, subnets, Internet Gateway, route tables

## Objective

Create the network from the IP plan. Only the **public** route table gets a route to the internet.

## Why

Private servers must have **no** `0.0.0.0/0` route so outbound traffic is forced through Squid later.

## Console steps

### 1. VPC

1. Console → **VPC** → Your VPCs → **Create VPC**.
2. Choose **VPC only**.
3. Name: `3tier-vpc`
4. IPv4 CIDR: `10.0.0.0/16`
5. Create.
6. Select the VPC → Actions → **Edit VPC settings** → enable **DNS hostnames** → Save.
7. Tags: `Name=3tier-vpc`, `Project=3tier`

### 2. Subnets (create four times)

**VPC** → Subnets → **Create subnet** → select `3tier-vpc`.

| Name | AZ | CIDR | Auto-assign public IPv4 |
|------|-----|------|-------------------------|
| `3tier-public-a` | `ap-south-1a` | `10.0.1.0/24` | **Enable** (after create: Actions → Edit subnet settings) |
| `3tier-public-b` | `ap-south-1b` | `10.0.2.0/24` | **Enable** |
| `3tier-private-a` | `ap-south-1a` | `10.0.11.0/24` | Leave disabled |
| `3tier-private-b` | `ap-south-1b` | `10.0.12.0/24` | Leave disabled |

Tag each with `Project=3tier`.

### 3. Internet Gateway

1. Internet gateways → **Create** → name `3tier-igw`.
2. Actions → **Attach to VPC** → `3tier-vpc`.

### 4. Public route table

1. Route tables → **Create** → name `3tier-public-rt` → VPC `3tier-vpc`.
2. Routes → Edit → Add: Destination `0.0.0.0/0` → Target = `3tier-igw`.
3. Subnet associations → Associate **both** `3tier-public-a` and `3tier-public-b`.

### 5. Private route table

1. Create `3tier-private-rt` (leave only the local `10.0.0.0/16` route — **do not** add IGW).
2. Associate **both** `3tier-private-a` and `3tier-private-b`.

## Validation

VPC → Resource map: 4 subnets, 2 route tables, IGW.  
Only `3tier-public-rt` has `0.0.0.0/0`.

## What comes next?

[../03-security-groups/](../03-security-groups/)
