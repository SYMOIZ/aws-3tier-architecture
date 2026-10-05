#!/usr/bin/env bash
# Phase 6 — Launch OpenVPN server + Elastic IP
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

VPN_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" --subnet-id "$PUB_A_ID" --private-ip-address "$VPN_IP" \
  --security-group-ids "$VPN_SG" "$REMOTE_SG" \
  --metadata-options HttpTokens=required \
  --user-data file://../userdata/openvpn.sh \
  --tag-specifications "$(tags instance openvpn-server)" "$(tags volume openvpn-server)" \
  --query 'Instances[0].InstanceId' --output text)
save VPN_ID "$VPN_ID"
aws ec2 wait instance-running --instance-ids "$VPN_ID"

# Router-type instance: disable source/destination check
aws ec2 modify-instance-attribute --instance-id "$VPN_ID" --no-source-dest-check

# Static public IP so the .ovpn profile never breaks
EIP_ALLOC=$(aws ec2 allocate-address --domain vpc \
  --tag-specifications "$(tags elastic-ip openvpn-eip)" --query AllocationId --output text)
save EIP_ALLOC "$EIP_ALLOC"
aws ec2 associate-address --instance-id "$VPN_ID" --allocation-id "$EIP_ALLOC" >/dev/null
save VPN_EIP "$(aws ec2 describe-addresses --allocation-ids "$EIP_ALLOC" \
  --query 'Addresses[0].PublicIp' --output text)"
aws ec2 wait instance-status-ok --instance-ids "$VPN_ID"

echo "OpenVPN ready. SSH: ssh -i $KEY_NAME.pem ubuntu@$VPN_EIP"
echo "Create client: sudo make-client my-pc $VPN_EIP"
echo "Then: scp -i $KEY_NAME.pem ubuntu@$VPN_EIP:~/my-pc.ovpn ."
