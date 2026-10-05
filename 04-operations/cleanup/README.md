# Cleanup / Teardown (SOP)

```bash
cd scripts
bash 99-teardown.sh
```

Deletes: ALB, target groups, all four instances, EIP, security groups, subnets, route tables, IGW, VPC, key pair, Resource Group.

**Does not delete:** IAM policy `3tier-deploy-policy`, group `3tier-admins`, user `3tier-deployer` — remove manually in IAM if unused.

## Warning

ALB, Elastic IP (if unattached), and public IPv4 continue to bill until deleted.
