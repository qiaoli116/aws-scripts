#!/bin/bash

# Function to convert time units to seconds
to_seconds() {
  local time_unit=$1
  local time_value=$2
  local seconds=0

  case $time_unit in
    d)
      seconds=$((time_value * 24 * 60 * 60))
      ;;
    h)
      seconds=$((time_value * 60 * 60))
      ;;
    m)
      seconds=$((time_value * 60))
      ;;
    s)
      seconds=$time_value
      ;;
  esac

  echo $seconds
}

# Parse duration argument
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 -d days -h hours -m minutes -s seconds"
  exit 1
fi

# Initialize duration values
days=0
hours=0
minutes=0
seconds=0

# Parse arguments
while getopts ":d:h:m:s:" opt; do
  case $opt in
    d)
      days=$OPTARG
      ;;
    h)
      hours=$OPTARG
      ;;
    m)
      minutes=$OPTARG
      ;;
    s)
      seconds=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# Calculate total duration in seconds
total_seconds=$(( $(to_seconds d $days) + $(to_seconds h $hours) + $(to_seconds m $minutes) + seconds ))

# Run AWS STS get-session-token command
output=$(aws sts get-session-token --duration-seconds "$total_seconds" 2>&1)

if [[ $? -ne 0 ]]; then
  echo "Failed to retrieve session token: $output"
  exit 1
fi

# Extract credentials from the output
access_key=$(echo "$output" | jq -r '.Credentials.AccessKeyId')
secret_key=$(echo "$output" | jq -r '.Credentials.SecretAccessKey')
session_token=$(echo "$output" | jq -r '.Credentials.SessionToken')
expiration=$(echo "$output" | jq -r '.Credentials.Expiration')

aws_account_id=$(aws sts get-caller-identity --query 'Account' --output text)
if [[ -n "$AWS_REGION" ]]; then
  current_region="$AWS_REGION"
else
  current_region="<target-region>"
fi
# Echo the values


# Print output
echo "calling aws sts get-session-token --duration-seconds $total_seconds"
echo "----------------------------------------"
echo "export AWS_ACCESS_KEY_ID=$access_key"
echo "export AWS_SECRET_ACCESS_KEY=$secret_key"
echo "export AWS_SESSION_TOKEN=$session_token"
echo "----------------------------------------"
echo "[default]"
echo "aws_access_key_id=$access_key"
echo "aws_secret_access_key=$secret_key"
echo "aws_session_token=$session_token"
echo "----------------------------------------"
echo "Credentials will expire at: $expiration"
echo "----------------------------------------"

echo "other userful commands"
echo "export CDK_DEPLOY_ACCOUNT=$aws_account_id"
echo "export CDK_DEPLOY_REGION=$current_region"
echo "export CDK_DEFAULT_ACCOUNT=$aws_account_id"
echo "export CDK_DEFAULT_REGION=$current_region"
