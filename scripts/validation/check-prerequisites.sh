#!/usr/bin/env bash
# Run from Git Bash before Part 02 deploy.
set -euo pipefail

echo "=== AWS identity ==="
aws sts get-caller-identity

echo "=== Region ==="
aws configure get region || echo "Set with: aws configure set region YOUR_REGION"

echo "=== Public IP (use as MY_IP/32 in security groups) ==="
curl -sS https://checkip.amazonaws.com

echo "=== OK ==="
