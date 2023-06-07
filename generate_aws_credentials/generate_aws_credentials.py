#!/usr/bin/env python3

import argparse
import subprocess
import json
from datetime import datetime, timedelta
import os

# Function to convert time units to seconds
def to_seconds(time_unit, time_value):
    if time_unit == 'd':
        return time_value * 24 * 60 * 60
    elif time_unit == 'H':
        return time_value * 60 * 60
    elif time_unit == 'm':
        return time_value * 60
    elif time_unit == 's':
        return time_value

# Parse duration argument
parser = argparse.ArgumentParser()
parser.add_argument('-d', type=int, default=0, help='Number of days')
parser.add_argument('-H', type=int, default=0, help='Number of hours')
parser.add_argument('-m', type=int, default=0, help='Number of minutes')
parser.add_argument('-s', type=int, default=0, help='Number of seconds')
args = parser.parse_args()

# Check if any arguments were provided
if not any(vars(args).values()):
    parser.print_help()
    exit(0)

# Calculate total duration in seconds
total_seconds = to_seconds('d', args.d) + to_seconds('H', args.H) + to_seconds('m', args.m) + args.s

# Run AWS STS get-session-token command
try:
    output = subprocess.check_output(['aws', 'sts', 'get-session-token', '--duration-seconds', str(total_seconds)], stderr=subprocess.STDOUT, universal_newlines=True)
except subprocess.CalledProcessError as e:
    print("Failed to retrieve session token:", e.output.strip())
    exit(1)

# Extract credentials from the output
credentials = json.loads(output)['Credentials']
access_key = credentials['AccessKeyId']
secret_key = credentials['SecretAccessKey']
session_token = credentials['SessionToken']
expiration = credentials['Expiration']





# Print output
print(f"calling aws sts get-session-token --duration-seconds {total_seconds}")
print("----------------------------------------")
print(f"export AWS_ACCESS_KEY_ID={access_key}")
print(f"export AWS_SECRET_ACCESS_KEY={secret_key}")
print(f"export AWS_SESSION_TOKEN={session_token}")
print("----------------------------------------")
print("[default]")
print(f"aws_access_key_id={access_key}")
print(f"aws_secret_access_key={secret_key}")
print(f"aws_session_token={session_token}")
print("----------------------------------------")
print(f"Credentials will expire at: {expiration}")


# Retrieve AWS Account ID
try:
    account_id_cmd = 'aws sts get-caller-identity --query Account --output text'
    account_id = subprocess.check_output(account_id_cmd, shell=True, text=True).strip()
except subprocess.CalledProcessError as e:
    print("Failed to retrieve session token:", e.output.strip())
    exit(1)


# Retrieve Current Region
if 'AWS_REGION' in os.environ:
    current_region = os.environ['AWS_REGION']
else:
    current_region = 'us-east-1'

print("----------------------------------------")
print(f"\nother userful commands:")
print(f"export CDK_DEPLOY_ACCOUNT={account_id}")
print(f"export CDK_DEPLOY_REGION={current_region}")
print(f"export CDK_DEFAULT_ACCOUNT={account_id}")
print(f"export CDK_DEFAULT_REGION={current_region}")

