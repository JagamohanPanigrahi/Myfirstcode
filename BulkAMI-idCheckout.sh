#!/bin/bash

CSV_FILE=$1
AWS_REGION=$2

if [ -z "$CSV_FILE" ]; then
    echo "Error: CSV file path is not provided."
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    echo "Error: AWS region is not provided."
    exit 1
fi

shopt -s nocasematch

while IFS=, read -r AWS_AMI_ID || [[ -n "$AWS_AMI_ID" ]]; do
    if [ -z "$AWS_AMI_ID" ]; then
        continue  # Skip empty lines
    fi

    # Check if the AMI ID is well-formed before making the API call
    if [[ ! "$AWS_AMI_ID" =~ ^ami-[a-fA-F0-9]{8,}$ ]]; then
        echo "Error: Invalid AMI ID format for $AWS_AMI_ID. Skipping..."
        continue
    fi

    status=$(aws ec2 describe-images --image-ids "$AWS_AMI_ID" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

    if [ $? -eq 0 ]; then
        echo "Status of AMI $AWS_AMI_ID in region $AWS_REGION: $status"
    else
        echo "Error describing AMI $AWS_AMI_ID in region $AWS_REGION. AWS CLI error message: $status"
    fi
done < "$CSV_FILE"
