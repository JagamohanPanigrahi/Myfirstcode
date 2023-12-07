#!/bin/bash

check_ami_status() {
    local ami_id=$1
    local region=$2

check_ami_status() {
    echo "Checking status of AMI $ami_id in region $region..."
    status=$(aws ec2 describe-images --image-ids $ami_id --region $region --query 'Images[0].State' --output text 2>&1)
    echo "Status of AMI $ami_id: $status"

    export AMI_STATUS=$status
}
