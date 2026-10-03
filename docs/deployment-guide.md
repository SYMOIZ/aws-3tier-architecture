# Deployment Guide (Overview)

This guide spans all four parts. **Part 01 is complete in the repository; Parts 02–04 are filled in incrementally.**

## Phase 0 — Read (no AWS charges)

1. [README.md](../README.md)
2. [01-understand/](../01-understand/)
3. [docs/cost.md](cost.md) — set a billing alarm

## Phase 1 — Network & identity (Part 02)

Follow [02-infrastructure/README.md](../02-infrastructure/README.md) as steps appear:

- IAM → VPC → subnets → routes → security groups → validate
- OpenVPN → Squid → EC2 tiers → database → ALB

**Do not continue** if a step’s validation fails.

## Phase 2 — Application (Part 03)

Install nginx frontend, API service, database schema, systemd units, environment variables (no secrets in git).

## Phase 3 — Operate (Part 04)

End-to-end tests, VPN client test, troubleshooting runbooks, backup, [cleanup](../04-operations/cleanup/README.md).

## Git Bash on Windows

```bash
cd "/c/Users/symoi/Desktop/New folder/aws-3tier-architecture"
export AWS_REGION=ap-south-1   # change to your region
aws sts get-caller-identity
```

## Values you must supply

| Variable | Example | Used for |
|----------|---------|----------|
| `AWS_REGION` | `ap-south-1` | All CLI |
| `MY_IP/32` | `203.0.113.10/32` | VPN, admin SSH |
| `KEY_NAME` | `nexusops-lab` | EC2 SSH key pair |
| `DB_PASSWORD` | (Secrets Manager / local only) | PostgreSQL |

Never commit secrets. See [.gitignore](../.gitignore).
