#!/usr/bin/env bash
# Create tag-based Resource Group (run as 3tier-deployer after Phase 1 IAM)
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

aws resource-groups create-group \
  --name 3tier-rg \
  --description "All resources of the 3-tier project" \
  --resource-query '{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"AWS::AllSupported\"],\"TagFilters\":[{\"Key\":\"Project\",\"Values\":[\"3tier\"]}]}"}' \
  --tags Project=3tier

echo "Resource group 3tier-rg created. List later with:"
echo "  aws resource-groups list-group-resources --group 3tier-rg --output table"
