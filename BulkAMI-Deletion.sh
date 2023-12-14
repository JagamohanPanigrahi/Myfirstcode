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

    # Check the state of the AMI before attempting to deregister
    state=$(aws ec2 describe-images --image-ids "$ami_id" --region "$AWS_REGION" --query 'Images[0].State' --output text 2>&1)

    if [ "$state" != "available" ]; then
        echo "Skipping AMI $ami_id in region $AWS_REGION as it is not in 'Available' state."
        continue
    fi

    echo "Deleting AMI $ami_id in region $AWS_REGION..."
    status=$(aws ec2 deregister-image --image-id "$ami_id" --region "$AWS_REGION" 2>&1)

    if [ $? -eq 0 ]; then
        echo "AMI $ami_id has been deleted in region $AWS_REGION."
    else
        echo "Error deleting AMI $ami_id in region $AWS_REGION. Error message: $status"
        exit 1
    fi
done < "$CSV_FILE"
