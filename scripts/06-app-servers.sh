#!/usr/bin/env bash
# Phase 7 — Frontend and Backend (private layer, no public IP)
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

render() {
  sed -e "s/__SQUID_IP__/$SQUID_IP/g" -e "s/__PROXY_PORT__/$PROXY_PORT/g" "$1" > "$2"
}
render ../userdata/frontend.sh /tmp/frontend.sh
render ../userdata/backend.sh /tmp/backend.sh

launch_private() { # name ip userdata sg1 sg2
  aws ec2 run-instances --image-id "$AMI_ID" --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" --subnet-id "$PRIV_A_ID" --private-ip-address "$2" \
    --no-associate-public-ip-address --security-group-ids "$4" "$5" \
    --metadata-options HttpTokens=required --user-data "file://$3" \
    --tag-specifications "$(tags instance "$1")" "$(tags volume "$1")" \
    --query 'Instances[0].InstanceId' --output text
}

save FRONTEND_ID "$(launch_private frontend "$FRONTEND_IP" /tmp/frontend.sh "$WEB_SG" "$CONNECT_SG")"
save BACKEND_ID "$(launch_private backend "$BACKEND_IP" /tmp/backend.sh "$BACKEND_SG" "$CONNECT_SG")"
aws ec2 wait instance-status-ok --instance-ids "$FRONTEND_ID" "$BACKEND_ID"
echo "Frontend $FRONTEND_IP and Backend $BACKEND_IP are running"
echo "SSH only after OpenVPN connects (Section 11 / Phase 9)."
