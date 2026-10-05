# Network Design (SOP IP plan)

**Region:** `ap-south-1` (change in `scripts/vars.sh` if needed).  
**VPC:** `3tier-vpc` · `10.0.0.0/16`

| Item | Name tag | CIDR / value | Route table |
|------|----------|--------------|-------------|
| Public subnet AZ a | 3tier-public-a | 10.0.1.0/24 | 3tier-public-rt (`0.0.0.0/0` → IGW) |
| Public subnet AZ b | 3tier-public-b | 10.0.2.0/24 | 3tier-public-rt |
| Private subnet AZ a | 3tier-private-a | 10.0.11.0/24 | 3tier-private-rt (local only) |
| Private subnet AZ b | 3tier-private-b | 10.0.12.0/24 | 3tier-private-rt |
| OpenVPN client pool | — | 10.8.0.0/24 | pushed by OpenVPN |
| Internet Gateway | 3tier-igw | attached to VPC | — |

## Fixed private IPs

| Host | IP |
|------|-----|
| Squid | 10.0.1.10 |
| OpenVPN | 10.0.1.20 (+ Elastic IP) |
| Frontend | 10.0.11.10 |
| Backend | 10.0.11.20 |

The private route table has **no** `0.0.0.0/0` route on purpose — that forces outbound traffic through Squid.

ALB needs two AZs (public-a + public-b). Servers run in AZ a; AZ b is ready for a second Frontend/Backend later.
