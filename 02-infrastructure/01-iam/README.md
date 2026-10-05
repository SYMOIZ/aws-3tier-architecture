# Phase 1 — IAM policy, group, user, Resource Group

Do this **once** as root or an existing admin. Then switch to `3tier-deployer`.

## Objective

Create least-privilege deploy identity restricted to `ap-south-1`.

## Why

Avoid day-to-day use of root. Scope permissions to EC2, ELB, Resource Groups, tags, and AMI lookup.

## Policy

File: [../../iam/policies/3tier-deploy-policy.json](../../iam/policies/3tier-deploy-policy.json)

### Console

1. IAM → Policies → Create policy → JSON → paste the file → name **`3tier-deploy-policy`**.
2. IAM → User groups → Create **`3tier-admins`** → attach `3tier-deploy-policy`.
3. IAM → Users → Create **`3tier-deployer`** → add to `3tier-admins`.
4. Assign MFA (recommended). Create access key for CLI → `aws configure` (region `ap-south-1`, output `json`).
5. Verify: `aws sts get-caller-identity` shows `user/3tier-deployer`.

### Resource Group

Tag every resource `Project=3tier`. Create group **`3tier-rg`**:

```bash
cd ../../scripts
bash 00-resource-group.sh
```

Or console: Resource Groups & Tag Editor → Tag based → Key `Project` Value `3tier` → name `3tier-rg`.

## Region note

The policy condition locks `aws:RequestedRegion` to `ap-south-1`. Change the JSON if you use another region, and update `scripts/vars.sh`.

## What comes next?

[../README.md](../README.md) Phase 2 — `bash 01-network.sh`
