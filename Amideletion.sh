#!/bin/bash

# Input parameters
AWS_AMI_ID=$1
AWS_REGION=$2

# Check if the AMI ID is provided
if [ -z "$AWS_AMI_ID" ]; then
    echo "Error: AMI ID is not provided."
    exit 1
fi

# Check if the AWS region is provided
if [ -z "$AWS_REGION" ]; then
    echo "Error: AWS region is not provided."
    exit 1
fi

echo "Deleting AMI $AWS_AMI_ID in region $AWS_REGION..."
aws ec2 deregister-image --image-id $AWS_AMI_ID --region $AWS_REGION

# Check if the deregister-image command was successful
if [ $? -eq 0 ]; then
    echo "AMI $AWS_AMI_ID has been deleted in region $AWS_REGION."
else
    echo "Error deleting AMI $AWS_AMI_ID in region $AWS_REGION."
    exit 1
fi
