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

while IFS=, read -r CSV_FILE || [[ -n "$CSV_FILE" ]]; do
    if [ -z "$CSV_FILE" ]; then
        continue  
    fi

    # Check if the AMI ID is well-formed before making the API call
    if [[ ! "$CSV_FILE" =~ ^ami-[a-fA-F0-9]{8,}$ ]]; then
        echo "Error: Invalid AMI ID format for $CSV_FILE. Skipping..."
        continue
    fi

    status=$(aws ec2 describe-images --image-ids "$v" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

    if [ $? -eq 0 ]; then
        echo "Status of AMI $CSV_FILE in region $AWS_REGION: $status"
    else
        echo "Error describing AMI $CSV_FILE in region $AWS_REGION. AWS CLI error message: $status"
    fi
done < "$CSV_FILE"
