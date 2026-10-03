# Security Overview

## Network

- Private subnets have no inbound path from the internet except via ALB (frontend) or VPN (admin).
- Database accepts connections only from the backend security group.

## Access

- Prefer **SSM Session Manager** in production over SSH; this lab uses **VPN + SSH** to teach classic patterns.
- Restrict VPN and admin SSH to **your IP**, not `0.0.0.0/0`.

## IAM

- Deployment user: scoped policies under [iam/](../iam/).
- EC2: instance profiles with minimal SSM/CloudWatch permissions—not broad S3 or `*` admin.

## Secrets

- Database passwords and OpenVPN keys stay out of git.
- Rotate VPN client certificates when people leave (Part 02 OpenVPN section).

## HTTPS

Lab may start on HTTP:80 at the ALB. Production should add ACM certificate and HTTPS:443 listener.

See [architecture/security-group-matrix.md](../architecture/security-group-matrix.md).
