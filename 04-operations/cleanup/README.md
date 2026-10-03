# Cleanup Guide (Preview)

**Run only when you want to delete the lab and stop charges.**

Order (children before parents):

1. Delete ALB listeners, target groups, load balancer
2. Terminate EC2 instances (VPN, Squid, frontend, backend)
3. Delete RDS instance (skip final snapshot if lab data disposable—or take one snapshot if you need it)
4. Release Elastic IPs not in use
5. Delete NAT Gateway if you added one (default design: none)
6. Delete security groups (after ENIs gone)
7. Delete subnets, route tables, IGW detach/delete, VPC
8. Delete IAM roles/policies created for the lab

## CLI pattern (Git Bash)

Replace IDs with your values:

```bash
aws elbv2 describe-load-balancers --query 'LoadBalancers[?contains(LoadBalancerName,`nexusops`)].LoadBalancerArn' --output text
# aws elbv2 delete-load-balancer --load-balancer-arn ...
```

Full scripted cleanup will live in `scripts/cleanup/` during Part 04 implementation.

## Warning

RDS snapshots and unattached EIPs continue to cost money until deleted.
