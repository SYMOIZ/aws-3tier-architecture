# Diagram Progression (Beginner-Friendly)

Start simple; add detail only after each layer makes sense.

## Step A — User and three tiers

```mermaid
flowchart TB
  U([Employee browser])
  T1[Presentation]
  T2[Application]
  T3[(Database)]
  U --> T1 --> T2 --> T3
```

## Step B — Add public vs private boxes

```mermaid
flowchart TB
  subgraph Public
    ALB[Load Balancer]
    VPN[VPN]
  end
  subgraph Private
    FE[Frontend]
    BE[Backend]
    DB[(Database)]
  end
  Internet([Internet]) --> ALB
  Internet --> VPN
  ALB --> FE
  FE --> BE
  BE --> DB
  VPN -.-> FE
  VPN -.-> BE
```

## Step C — Add Squid for outbound

```mermaid
flowchart LR
  BE[Backend]
  FE[Frontend]
  SQ[Squid]
  NET([Internet])
  FE --> SQ
  BE --> SQ
  SQ --> NET
```

## Reference — corrected security group names

Aligned with [../../architecture/security-group-matrix.md](../../architecture/security-group-matrix.md):

| SG | Attached to |
|----|-------------|
| ALB-SG | Load balancer |
| VPN-SG | OpenVPN server |
| PROXY-SG | Squid |
| WEB-SG | Frontend |
| BACKEND-SG | Backend |
| CONNECT-SG | Frontend & Backend (SSH from VPN) |
| DB-SG | Database |

Friend’s diagram used `APP-SG` for the load balancer; this repo uses **ALB-SG** to avoid confusion with “application tier.”
