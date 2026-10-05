#!/usr/bin/env bash
# Phase 8 — Application Load Balancer (path /api/* → backend, default → frontend)
set -euo pipefail
cd "$(dirname "$0")"
source ./vars.sh

FE_TG=$(aws elbv2 create-target-group --name 3tier-frontend-tg --protocol HTTP --port 80 \
  --vpc-id "$VPC_ID" --target-type instance --health-check-path / \
  --tags Key=Project,Value="$PROJECT" --query 'TargetGroups[0].TargetGroupArn' --output text)
save FE_TG "$FE_TG"

BE_TG=$(aws elbv2 create-target-group --name 3tier-backend-tg --protocol HTTP --port 8000 \
  --vpc-id "$VPC_ID" --target-type instance --health-check-path /api/health \
  --tags Key=Project,Value="$PROJECT" --query 'TargetGroups[0].TargetGroupArn' --output text)
save BE_TG "$BE_TG"

aws elbv2 register-targets --target-group-arn "$FE_TG" --targets Id="$FRONTEND_ID",Port=80
aws elbv2 register-targets --target-group-arn "$BE_TG" --targets Id="$BACKEND_ID",Port=8000

ALB_ARN=$(aws elbv2 create-load-balancer --name 3tier-alb --type application --scheme internet-facing \
  --subnets "$PUB_A_ID" "$PUB_B_ID" --security-groups "$APP_SG" \
  --tags Key=Project,Value="$PROJECT" Key=Name,Value=3tier-alb \
  --query 'LoadBalancers[0].LoadBalancerArn' --output text)
save ALB_ARN "$ALB_ARN"
aws elbv2 wait load-balancer-available --load-balancer-arns "$ALB_ARN"

LISTENER_ARN=$(aws elbv2 create-listener --load-balancer-arn "$ALB_ARN" --protocol HTTP --port 80 \
  --default-actions Type=forward,TargetGroupArn="$FE_TG" \
  --query 'Listeners[0].ListenerArn' --output text)
save LISTENER_ARN "$LISTENER_ARN"

aws elbv2 create-rule --listener-arn "$LISTENER_ARN" --priority 10 \
  --conditions Field=path-pattern,Values='/api/*' \
  --actions Type=forward,TargetGroupArn="$BE_TG" >/dev/null

save ALB_DNS "$(aws elbv2 describe-load-balancers --load-balancer-arns "$ALB_ARN" \
  --query 'LoadBalancers[0].DNSName' --output text)"
echo "Open: http://$ALB_DNS"
echo "API:  http://$ALB_DNS/api/health"
echo "Wait 1–2 minutes for targets to become healthy."
