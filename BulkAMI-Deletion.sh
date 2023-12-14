#!/bin/bash

CSV_FILE=$1
AWS_REGION=$2

shopt -s nocasematch

while IFS=, read -r ami_id || [[ -n "$ami_id" ]]; do
   
    if [ -z "$ami_id" ]; then
        continue
    fi

    if [[ ! "$ami_id" =~ ^ami-[a-fA-F0-9]{8,}$ ]]; then
        echo "Error: Invalid AMI ID format for $ami_id. Skipping...this job"
        continue
    fi

    echo "Deleting AMI $ami_id in region $AWS_REGION..."
    status=$(aws ec2 deregister-image --image-ids "$ami_id" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

    if [ $? -eq 0 ]; then
        echo "AMI $ami_id has been deleted in region $AWS_REGION."
    else
        echo "Error deleting AMI $ami_id in region $AWS_REGION."
        exit 1
    fi
done < "$CSV_FILE"
