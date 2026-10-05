#!/usr/bin/env bash
# Phase 5 — Launch Squid forward proxy
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

SQUID_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" --subnet-id "$PUB_A_ID" --private-ip-address "$SQUID_IP" \
  --security-group-ids "$REMOTE_SG" "$PROXY_SG" \
  --metadata-options HttpTokens=required \
  --user-data file://../userdata/squid.sh \
  --tag-specifications "$(tags instance squid-proxy)" "$(tags volume squid-proxy)" \
  --query 'Instances[0].InstanceId' --output text)
save SQUID_ID "$SQUID_ID"
aws ec2 wait instance-status-ok --instance-ids "$SQUID_ID"
save SQUID_PUBLIC_IP "$(aws ec2 describe-instances --instance-ids "$SQUID_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)"

echo "Squid ready. SSH: ssh -i $KEY_NAME.pem ubuntu@$SQUID_PUBLIC_IP"
echo "Check: sudo systemctl status squid --no-pager"
echo "Check: curl -sI -x http://127.0.0.1:8888 https://ubuntu.com | head -1"
