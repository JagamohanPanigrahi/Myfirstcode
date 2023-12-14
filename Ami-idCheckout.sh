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

while IFS=, read -r ami_id || [[ -n "$ami_id" ]]; do
    # Trim leading and trailing whitespace from AMI ID
    ami_id=$(echo "$ami_id" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    if [ -z "$ami_id" ]; then
        continue
    fi

    # Check if the AMI ID is well-formed before making the API call
    if [[ ! "$ami_id" =~ ^ami-[a-fA-F0-9]{8,}$ ]]; then
        echo "Error: Invalid AMI ID format for $ami_id. Skipping..."
        continue
    fi

    status=$(aws ec2 describe-images --image-ids "$ami_id" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

    if [ $? -eq 0 ]; then
        echo "Status of AMI $ami_id in region $AWS_REGION: $status"
    else
        echo "Error describing AMI $ami_id in region $AWS_REGION. AWS CLI error message: $status"
    fi
done < "$CSV_FILE"
