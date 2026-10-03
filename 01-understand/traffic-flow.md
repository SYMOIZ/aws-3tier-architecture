# Traffic Flow

## Objective

Describe how packets move for each use case.

## 1. Employee opens the website

```text
Browser → Internet → ALB:443/80 → Frontend:80 → (static/UI)
```

API calls from the browser (same origin or configured API path):

```text
Browser → ALB → Frontend → Backend:8000 → PostgreSQL:5432
```

The backend is **not** registered as a public ALB target in the default design.

## 2. Administrator SSH to frontend

```text
Admin laptop → OpenVPN:1194 → VPN tunnel → Frontend:22
```

Security group **Connect-SG** allows SSH only from **VPN-SG**.

## 3. Backend calls the database

```text
Backend → DB:5432 (DB-SG allows backend SG only)
```

## 4. Private instance downloads packages

```text
Backend → Squid:8888 → Internet
```

Instances use `http_proxy` / `https_proxy` environment variables or apt/yum proxy settings pointing at Squid.

## 5. What must never happen

- Internet → Backend:8000 directly
- Internet → Database:5432
- `0.0.0.0/0` on SSH for private instances

## Validation mindset

After each Part 02 step, you will run checks listed in that step’s **Validation** section (e.g. `curl` via ALB, `psql` from backend only).

## What comes next?

[diagrams/concept-progression.md](diagrams/concept-progression.md)
