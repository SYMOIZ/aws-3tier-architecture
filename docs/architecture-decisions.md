# Architecture Decision Record

## ADR-001: Squid instead of NAT Gateway

**Status:** Accepted (SOP)  
**Decision:** Private route table has no `0.0.0.0/0`; egress via Squid `:8888`.

## ADR-002: ALB path routing to Backend

**Status:** Accepted (SOP)  
**Decision:** Default listener → Frontend; path `/api/*` → Backend target group on port 8000.  
**Note:** An earlier draft of this repo proposed Frontend-only ALB targets; the SOP (and original diagram) expose the API via ALB path rules.

## ADR-003: No separate database tier in this SOP

**Status:** Accepted for current SOP scope  
**Context:** The SOP deploys Frontend + Backend only. A private DB tier can be added later as an extension.

## ADR-004: Dual AZ for ALB, single AZ for servers

**Status:** Accepted  
**Decision:** Public/private subnets in AZ a and b; EC2 instances only in AZ a initially.

## ADR-005: Region lock on IAM policy

**Status:** Accepted  
**Decision:** `3tier-deploy-policy` conditions on `aws:RequestedRegion = ap-south-1`.

## ADR-006: Manual Console deploy, not Terraform

**Status:** Accepted  
**Decision:** Primary path is AWS Console click-by-click. Optional AWS CLI bash scripts only. **No Terraform** in this repository so learners see each resource.
