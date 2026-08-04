#!/usr/bin/env bash
set -euo pipefail

# ── Deploy the chatbot backend to AWS ──
# Prerequisites:
#   1. AWS CLI configured (~/.aws/credentials)
#   2. AWS SAM CLI installed: brew install aws-sam-cli
#   3. Bedrock model access enabled for amazon.titan-text-lite-v1 in us-east-1

STACK_NAME="langfordzl-chatbot"
REGION="us-east-1"

echo "==> Building SAM application..."
sam build --template-file template.yaml --use-container

echo "==> Deploying stack: ${STACK_NAME}..."
sam deploy \
  --stack-name "${STACK_NAME}" \
  --region "${REGION}" \
  --capabilities CAPABILITY_IAM \
  --resolve-s3 \
  --no-confirm-changeset

echo ""
echo "==> Deployment complete!"
echo ""
echo "==> Your API URL:"
aws cloudformation describe-stacks \
  --stack-name "${STACK_NAME}" \
  --region "${REGION}" \
  --query 'Stacks[0].Outputs[?OutputKey==`ChatApiUrl`].OutputValue' \
  --output text

echo ""
echo "NEXT STEP: Copy the API URL above into _config.yml (chatbot_api_url), then push to GitHub."
