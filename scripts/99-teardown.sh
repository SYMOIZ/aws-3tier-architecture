#!/usr/bin/env bash
# Teardown — deletes ALB, instances, EIP, SGs, subnets, VPC (not IAM from Phase 1)
set -uo pipefail
cd "$(dirname "$0")"
source ./vars.sh

aws elbv2 delete-load-balancer --load-balancer-arn "$ALB_ARN"
aws elbv2 wait load-balancers-deleted --load-balancer-arns "$ALB_ARN"
aws elbv2 delete-target-group --target-group-arn "$FE_TG"
aws elbv2 delete-target-group --target-group-arn "$BE_TG"

aws ec2 terminate-instances --instance-ids "$SQUID_ID" "$VPN_ID" "$FRONTEND_ID" "$BACKEND_ID" >/dev/null
aws ec2 wait instance-terminated --instance-ids "$SQUID_ID" "$VPN_ID" "$FRONTEND_ID" "$BACKEND_ID"
aws ec2 release-address --allocation-id "$EIP_ALLOC"

# Delete groups that reference others first; retry while ALB ENIs disappear
for SG in "$CONNECT_SG" "$PROXY_SG" "$WEB_SG" "$BACKEND_SG" "$APP_SG" "$VPN_SG" "$REMOTE_SG"; do
  for i in 1 2 3 4 5 6; do
    aws ec2 delete-security-group --group-id "$SG" && break
    sleep 20
  done
done

for S in "$PUB_A_ID" "$PUB_B_ID" "$PRIV_A_ID" "$PRIV_B_ID"; do
  aws ec2 delete-subnet --subnet-id "$S"
done
aws ec2 delete-route-table --route-table-id "$PUB_RT_ID"
aws ec2 delete-route-table --route-table-id "$PRIV_RT_ID"
aws ec2 detach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID"
aws ec2 delete-internet-gateway --internet-gateway-id "$IGW_ID"
aws ec2 delete-vpc --vpc-id "$VPC_ID"
aws ec2 delete-key-pair --key-name "$KEY_NAME"
aws resource-groups delete-group --group 3tier-rg >/dev/null || true

echo "Teardown complete"
mv ids.sh ids.sh.deleted 2>/dev/null || true
echo "IAM policy/group/user from Phase 1 were NOT deleted — remove them manually if unused."
