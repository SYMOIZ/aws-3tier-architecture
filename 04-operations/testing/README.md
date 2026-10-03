# Testing Checklists

## VPC / subnets

- [ ] VPC CIDR is `10.0.0.0/16`
- [ ] Public subnet route: `0.0.0.0/0` → IGW
- [ ] Private subnets have no IGW default route

## Security groups

- [ ] No `0.0.0.0/0` on port 22 for private instances
- [ ] DB-SG allows 5432 only from BACKEND-SG

## VPN

- [ ] Client connects on UDP 1194
- [ ] Client can reach `10.0.10.x` after push route

## Application

- [ ] ALB target health: healthy
- [ ] Backend not reachable from public internet on :8000

Mark items **UNVERIFIED** until you run them in your account.
