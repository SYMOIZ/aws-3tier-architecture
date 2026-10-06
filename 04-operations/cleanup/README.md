# Cleanup / reset by hand (Console)

**All teardown / reset steps are in this file.** You do not need other folders for cleanup.

Delete in this order so dependencies do not block you.

1. **EC2 → Load Balancers** → delete `3tier-alb`
2. **Target Groups** → delete `3tier-frontend-tg` and `3tier-backend-tg`
3. **Instances** → terminate `frontend`, `backend`, `squid-proxy`, `openvpn-server`
4. **Elastic IPs** → release the OpenVPN EIP (important — idle EIP costs money)
5. **Security Groups** → delete Connect-SG, Proxy-SG, Web-SG, Backend-SG, APP-SG, VPN-SG, Remote-SG (retry if ENIs still detaching)
6. **Subnets** → delete all four `3tier-*` subnets
7. **Route tables** → delete `3tier-public-rt` and `3tier-private-rt`
8. **Internet Gateway** → detach then delete `3tier-igw`
9. **VPC** → delete `3tier-vpc`
10. **Key Pairs** → delete `3tier-key` (optional)
11. **Resource Groups** → delete `3tier-rg` (optional)
12. **IAM** (optional): remove `3tier-deployer`, `3tier-admins`, `3tier-deploy-policy`

## Warning

ALB, Elastic IP (if unattached), and public IPv4 keep billing until deleted.

Optional script teardown: `scripts/99-teardown.sh` (not required for hand deploy).
