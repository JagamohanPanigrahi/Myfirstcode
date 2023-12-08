#!/bin/bash

# Input parameters
AWS_AMI_ID=$1
AWS_REGION=$2

# Validate input parameters
if [ -z "$AWS_AMI_ID" ]; then
    echo "Error: AMI ID is not provided."
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    echo "Error: AWS region is not provided."
    exit 1
fi

# AWS CLI command to check the status of the specified AMI
status=$(aws ec2 describe-images --image-ids "$AWS_AMI_ID" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

# Check if the describe-images command was successful
if [ $? -eq 0 ]; then
    echo "Status of AMI $AWS_AMI_ID in region $AWS_REGION: $status"
else
    echo "Error describing AMI $AWS_AMI_ID in region $AWS_REGION: $status"
    exit 1
fi
