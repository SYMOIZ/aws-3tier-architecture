# Execution map (short)

This is a short pointer. The full story is on the **[root README](../README.md)**.

## Squid in one line

Forward proxy at `10.0.1.10:8888` so private Frontend/Backend can reach the internet for packages **without** a NAT Gateway. Code: `userdata/squid.sh` (runs on EC2 boot, not on your PC).

## Where things run

| Artifact | Run location |
|----------|--------------|
| `02-infrastructure/*/README.md` | You + AWS Console |
| `userdata/*.sh` | Inside EC2 at first boot (paste as User data) |
| `scripts/*.sh` | Optional Git Bash + AWS CLI — skip for hand deploy |
| `04-operations/cleanup/` | Console deletes (reset lives here) |

## Sequence

IAM → VPC → SG → Squid → OpenVPN → Frontend/Backend → ALB → VPN client → Test → Cleanup
