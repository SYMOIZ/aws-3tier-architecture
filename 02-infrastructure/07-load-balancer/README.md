# Phase 8 — Application Load Balancer (Console)

## Objective

Internet-facing ALB: default traffic → Frontend `:80`; path `/api/*` → Backend `:8000`.

**COST WARNING:** ALB is **not** Free Tier (~$16+/month + usage). Create only when ready to test; delete when done.

## Target groups

### Frontend TG

1. EC2 → Target Groups → **Create**.
2. Type: **Instances**, name `3tier-frontend-tg`, Protocol HTTP, Port **80**, VPC `3tier-vpc`.
3. Health check path: `/`
4. Register target: `frontend` on port 80 → Create.

### Backend TG

1. Create `3tier-backend-tg`, HTTP, Port **8000**.
2. Health check path: `/api/health`
3. Register `backend` on port **8000**.

## Load balancer

1. Load Balancers → **Create** → **Application Load Balancer**.
2. Name: `3tier-alb`
3. Scheme: **Internet-facing**, IPv4
4. VPC: `3tier-vpc`
5. Mappings: **both** `3tier-public-a` and `3tier-public-b`
6. Security group: **only** `APP-SG` (remove default)
7. Listener HTTP:80 → Forward to `3tier-frontend-tg` → Create

### Path rule for API

1. Open the ALB → Listeners → HTTP:80 → **Manage rules** / Add rule.
2. Condition: Path is `/api/*`
3. Action: Forward to `3tier-backend-tg`
4. Priority: **10**

## Validation (wait 1–2 minutes)

- Both target groups: **Healthy**
- Browser: `http://<ALB_DNS>` → “Frontend is up” + Backend JSON
- `http://<ALB_DNS>/api/health` → `{"status":"ok"}`

## Production note (later)

Add ACM cert + HTTPS:443; redirect HTTP→HTTPS. Not required for this lab.

## What comes next?

[../../03-deployment/vpn-client.md](../../03-deployment/vpn-client.md)
