#!/bin/bash

CSV_FILE=$1
AWS_REGION=$2

if [ -z "$CSV_FILE" ]; then
    echo "Error: AMI ID is not provided."
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    echo "Error: AWS region is not provided."
    exit 1
fi

shopt -s nocasematch

while IFS=, read -r AWS_AMI_ID
do
    status=$(aws ec2 describe-images --image-ids "$AWS_AMI_ID" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

    if [[ "$status" == "Available" ]]; then
        echo "Status of AMI $AWS_AMI_ID in region $AWS_REGION: $status"
    else
        echo "Error describing AMI $AWS_AMI_ID in region $AWS_REGION: $status"
    fi
done < "$CSV_FILE
