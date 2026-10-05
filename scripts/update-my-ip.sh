#!/usr/bin/env bash
# Update Remote-SG and VPN-SG when your ISP gives you a new public IP
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

swap() { # sg protocol port
  for OLD in $(aws ec2 describe-security-groups --group-ids "$1" \
    --query "SecurityGroups[0].IpPermissions[?FromPort==\`$3\`].IpRanges[].CidrIp" --output text); do
    aws ec2 revoke-security-group-ingress --group-id "$1" --protocol "$2" --port "$3" --cidr "$OLD"
  done
  aws ec2 authorize-security-group-ingress --group-id "$1" --protocol "$2" --port "$3" --cidr "$MY_IP" >/dev/null
}

swap "$VPN_SG" udp 1194
swap "$REMOTE_SG" tcp 22
echo "Allowed $MY_IP on VPN-SG and Remote-SG"
