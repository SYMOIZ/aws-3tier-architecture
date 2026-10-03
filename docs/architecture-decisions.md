# Architecture Decision Record (ADR)

## ADR-001: Squid instead of NAT Gateway

**Status:** Accepted for lab  
**Context:** NAT Gateway has significant fixed monthly cost.  
**Decision:** Private instances use Squid forward proxy for outbound HTTP/HTTPS.  
**Consequences:** Must configure proxy on OS; some tools need explicit proxy env vars.

## ADR-002: Backend not attached to ALB

**Status:** Accepted  
**Context:** Friend diagram showed ALB → backend:8000.  
**Decision:** Only frontend is an ALB target; frontend calls backend privately.  
**Consequences:** Clearer 3-tier story; frontend must proxy `/api` or equivalent.

## ADR-003: RDS PostgreSQL default

**Status:** Proposed (confirm at Part 02 database step)  
**Context:** EC2 PostgreSQL is cheaper but more ops work.  
**Decision:** Document RDS `db.t3.micro` as default; EC2 PostgreSQL as alternative appendix.  
**Consequences:** Free Tier eligibility for 12 months on new accounts; snapshot storage costs.

## ADR-004: Single AZ first

**Status:** Accepted for initial deploy  
**Context:** Cost and complexity for learners.  
**Decision:** One AZ; HA patterns documented later.  
**Consequences:** No cross-AZ redundancy during lab.

## ADR-005: Manual before Terraform

**Status:** Accepted  
**Context:** Repository is educational.  
**Decision:** CLI/console steps first; Terraform module after manual path is complete.  
**Consequences:** Slower first deploy; better understanding.
