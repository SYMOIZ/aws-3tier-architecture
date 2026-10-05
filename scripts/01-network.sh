#!/usr/bin/env bash
# Phase 2 — VPC, subnets, Internet Gateway, route tables
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh
: > ./ids.sh  # start a fresh IDs file

# VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block "$VPC_CIDR" \
  --tag-specifications "$(tags vpc 3tier-vpc)" --query Vpc.VpcId --output text)
save VPC_ID "$VPC_ID"
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-hostnames '{"Value":true}'
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-support '{"Value":true}'

# Subnets
mk_subnet() { # name cidr az
  aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block "$2" --availability-zone "$3" \
    --tag-specifications "$(tags subnet "$1")" --query Subnet.SubnetId --output text
}
save PUB_A_ID "$(mk_subnet 3tier-public-a "$PUB_A_CIDR" "$AZ_A")"
save PUB_B_ID "$(mk_subnet 3tier-public-b "$PUB_B_CIDR" "$AZ_B")"
save PRIV_A_ID "$(mk_subnet 3tier-private-a "$PRIV_A_CIDR" "$AZ_A")"
save PRIV_B_ID "$(mk_subnet 3tier-private-b "$PRIV_B_CIDR" "$AZ_B")"
for s in "$PUB_A_ID" "$PUB_B_ID"; do
  aws ec2 modify-subnet-attribute --subnet-id "$s" --map-public-ip-on-launch
done

# Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
  --tag-specifications "$(tags internet-gateway 3tier-igw)" \
  --query InternetGateway.InternetGatewayId --output text)
save IGW_ID "$IGW_ID"
aws ec2 attach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID"

# Public route table: 0.0.0.0/0 -> IGW
PUB_RT_ID=$(aws ec2 create-route-table --vpc-id "$VPC_ID" \
  --tag-specifications "$(tags route-table 3tier-public-rt)" \
  --query RouteTable.RouteTableId --output text)
save PUB_RT_ID "$PUB_RT_ID"
aws ec2 create-route --route-table-id "$PUB_RT_ID" --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID" >/dev/null
aws ec2 associate-route-table --route-table-id "$PUB_RT_ID" --subnet-id "$PUB_A_ID" >/dev/null
aws ec2 associate-route-table --route-table-id "$PUB_RT_ID" --subnet-id "$PUB_B_ID" >/dev/null

# Private route table: local route only (internet goes via Squid)
PRIV_RT_ID=$(aws ec2 create-route-table --vpc-id "$VPC_ID" \
  --tag-specifications "$(tags route-table 3tier-private-rt)" \
  --query RouteTable.RouteTableId --output text)
save PRIV_RT_ID "$PRIV_RT_ID"
aws ec2 associate-route-table --route-table-id "$PRIV_RT_ID" --subnet-id "$PRIV_A_ID" >/dev/null
aws ec2 associate-route-table --route-table-id "$PRIV_RT_ID" --subnet-id "$PRIV_B_ID" >/dev/null

echo "Network ready in $VPC_ID"
