#!/usr/bin/env bash
# Phase 4 — Key pair and Ubuntu 24.04 AMI ID
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

aws ec2 create-key-pair --key-name "$KEY_NAME" --key-type ed25519 \
  --tag-specifications "$(tags key-pair "$KEY_NAME")" \
  --query KeyMaterial --output text > "$KEY_NAME.pem"
chmod 400 "$KEY_NAME.pem"

AMI_ID=$(aws ssm get-parameters \
  --names /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id \
  --query 'Parameters[0].Value' --output text)
save AMI_ID "$AMI_ID"

echo "Key written to $(pwd)/$KEY_NAME.pem"
echo "On Windows if SSH says key is too open, run in PowerShell:"
echo "  icacls .\\$KEY_NAME.pem /inheritance:r /grant:r \"\$(\$env:USERNAME):(R)\""
