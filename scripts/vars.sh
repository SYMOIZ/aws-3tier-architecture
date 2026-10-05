#!/usr/bin/env bash
# Common variables for the 3-tier SOP. Every later script starts with: source ./vars.sh
# On Windows, run from Git Bash inside the scripts/ folder (or set SCRIPT_DIR).

export AWS_REGION="ap-south-1"
export AWS_DEFAULT_REGION="$AWS_REGION"
export AZ_A="${AWS_REGION}a"
export AZ_B="${AWS_REGION}b"
export PROJECT="3tier"
export MY_IP="$(curl -s https://checkip.amazonaws.com)/32"
export KEY_NAME="3tier-key"
export INSTANCE_TYPE="t3.micro"
export VPC_CIDR="10.0.0.0/16"
export PUB_A_CIDR="10.0.1.0/24"
export PUB_B_CIDR="10.0.2.0/24"
export PRIV_A_CIDR="10.0.11.0/24"
export PRIV_B_CIDR="10.0.12.0/24"
export SQUID_IP="10.0.1.10"
export VPN_IP="10.0.1.20"
export FRONTEND_IP="10.0.11.10"
export BACKEND_IP="10.0.11.20"
export PROXY_PORT="8888"

# Load IDs created by earlier phases (file is created in Phase 2)
[ -f ./ids.sh ] && source ./ids.sh

# Tag helper: every resource gets Project=3tier (used by the Resource Group)
tags() {
  echo "ResourceType=$1,Tags=[{Key=Name,Value=$2},{Key=Project,Value=$PROJECT}]"
}

save() {
  echo "export $1=\"$2\"" >> ./ids.sh
  export "$1=$2"
  echo "$1=$2"
}
