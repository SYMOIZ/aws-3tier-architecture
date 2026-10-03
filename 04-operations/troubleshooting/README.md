# Troubleshooting

## VPN connects but no SSH to private host

- Confirm **Connect-SG** allows 22 from **VPN-SG** (not from your laptop IP directly).
- Confirm OpenVPN pushes route for `10.0.0.0/16`.
- Check instance is in `private-app` subnet with correct SG attached.

## Frontend unhealthy on ALB

- Security group: ALB-SG → WEB-SG on port 80.
- Health check path/port matches nginx listen port.
- Target registered in correct VPC/subnet.

## Backend cannot reach database

- RDS/DB in `private-db` subnet group.
- DB-SG inbound only from BACKEND-SG.
- Backend uses RDS endpoint hostname, not public IP.

## Private instance cannot download packages

- Squid PROXY-SG allows 8888 from WEB-SG and BACKEND-SG.
- `http_proxy` / `https_proxy` set on instance.
- Squid can reach internet (public subnet + IGW route).

## Run validation script

```bash
./scripts/validation/check-prerequisites.sh
```
