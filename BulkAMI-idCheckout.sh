#!/bin/bash

CSV_FILE=$1
AWS_REGION=$2


trim() {
    echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

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
    ami_id=$(trim "$ami_id")

    if [ -z "$ami_id" ]; then
        continue
    fi

    if [[ ! "$ami_id" =~ ^ami-[a-fA-F0-9]{8,}$ ]]; then
        echo "Error: Invalid AMI ID format for $ami_id. Skipping...this job"
        exit 1
    else
    status=$(aws ec2 describe-images --image-ids "$ami_id" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

    if [ "$state" == "available" ]; then
        echo "Status of AMI $ami_id in region $AWS_REGION: $status"
    else
        echo "Error describing AMI $ami_id in region $AWS_REGION. error message: $status"
        exit 1
    fi
done < "$CSV_FILE"
