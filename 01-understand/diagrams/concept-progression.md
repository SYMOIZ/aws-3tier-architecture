# Diagram Progression

## Step A — Two layers

```mermaid
flowchart TB
  subgraph Public
    ALB[ALB]
    SQ[Squid]
    VPN[OpenVPN]
  end
  subgraph Private
    FE[Frontend]
    BE[Backend]
  end
  Internet([Internet]) --> ALB
  Internet --> VPN
  ALB --> FE
  ALB --> BE
  FE --> SQ
  BE --> SQ
  VPN -.-> FE
  VPN -.-> BE
  SQ --> Internet
```

## Step B — ALB path rules

```text
ALB :80
  ├─ default  → Frontend :80
  └─ /api/*   → Backend  :8000
```

## Security group names (SOP)

APP-SG · Web-SG · Backend-SG · Proxy-SG · Remote-SG · VPN-SG · Connect-SG
