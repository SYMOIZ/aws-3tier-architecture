#!/usr/bin/env bash
# Phase 3 — Security groups (create all groups first, then rules)
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

mk_sg() { # name description
  aws ec2 create-security-group --vpc-id "$VPC_ID" --group-name "$1" --description "$2" \
    --tag-specifications "$(tags security-group "$1")" --query GroupId --output text
}

save APP_SG "$(mk_sg APP-SG 'ALB: HTTP 80 from anywhere')"
save WEB_SG "$(mk_sg Web-SG 'Frontend: 80 from APP-SG')"
save BACKEND_SG "$(mk_sg Backend-SG 'Backend: 8000 from APP-SG')"
save PROXY_SG "$(mk_sg Proxy-SG 'Squid: 8888 from Web-SG and Backend-SG')"
save REMOTE_SG "$(mk_sg Remote-SG 'SSH 22 from my IP')"
save VPN_SG "$(mk_sg VPN-SG 'OpenVPN UDP 1194 from my IP')"
save CONNECT_SG "$(mk_sg Connect-SG 'SSH 22 from VPN-SG')"

from_cidr() {
  aws ec2 authorize-security-group-ingress --group-id "$1" --protocol "$2" --port "$3" --cidr "$4" >/dev/null
}
from_sg() {
  aws ec2 authorize-security-group-ingress --group-id "$1" --protocol "$2" --port "$3" --source-group "$4" >/dev/null
}

from_cidr "$APP_SG" tcp 80 0.0.0.0/0
from_sg "$WEB_SG" tcp 80 "$APP_SG"
from_sg "$BACKEND_SG" tcp 8000 "$APP_SG"
from_sg "$PROXY_SG" tcp "$PROXY_PORT" "$WEB_SG"
from_sg "$PROXY_SG" tcp "$PROXY_PORT" "$BACKEND_SG"
from_cidr "$REMOTE_SG" tcp 22 "$MY_IP"
from_cidr "$VPN_SG" udp 1194 "$MY_IP"
from_sg "$CONNECT_SG" tcp 22 "$VPN_SG"

aws ec2 describe-security-groups --filters Name=vpc-id,Values="$VPC_ID" \
  --query 'SecurityGroups[].{Name:GroupName,Id:GroupId}' --output table

echo "Security groups ready. MY_IP=$MY_IP"
