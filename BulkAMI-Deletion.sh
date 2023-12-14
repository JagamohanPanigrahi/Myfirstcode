#!/bin/bash

CSV_FILE=$1
AWS_REGION=$2

trim() {
    echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

shopt -s nocasematch

while IFS=, read -r ami_id || [[ -n "$ami_id" ]]; do
    ami_id=$(trim "$ami_id")

    if [ -z "$ami_id" ]; then
        continue
    fi

    if [[ ! "$ami_id" =~ ^ami-[a-fA-F0-9]{8,}$ ]]; then
        echo "Error: Invalid AMI ID format for $ami_id. Skipping...this job"
        continue
    fi

    echo "Deleting AMI $ami_id in region $AWS_REGION..."
    status=$(aws ec2 deregister-image --image-id "$ami_id" --region "$AWS_REGION" 2>&1)

    if [ $? -eq 0 ]; then
        echo "AMI $ami_id has been deleted in region $AWS_REGION."
    else
        echo "Error deleting AMI $ami_id in region $AWS_REGION. Error message: $status"
        
    fi
done < "$CSV_FILE"
