#!/bin/bash


check_ami_status() {
    local ami_id=$1
    local region=$2

    echo "Checking status of AMI $ami_id in region $region..."
    status=$(aws ec2 describe-images --image-ids $ami_id --region $region --query 'Images[0].State' --output text 2>&1)

    if [[ $status == "available" ]]; then
        echo "AMI $ami_id is available in region $region."
        return 0
    else
        echo "AMI $ami_id is not available in region $region or does not exist."
        return 1
    fi
}

# Function to delete the AMI in a region
delete_ami() {
    local ami_id=$1
    local region=$2

    echo "Deleting AMI $ami_id in region $region..."
    aws ec2 deregister-image --image-id $ami_id --region $region
    echo "AMI $ami_id has been deleted in region $region."
}


read -p "Enter the AMI ID: " ami_id
read -p "Enter the regions (comma-separated, e.g., us-west-1,us-east-2): " regions_input


IFS=',' read -r -a regions <<< "$regions_input"


for region in "${regions[@]}"
do
    if check_ami_status $ami_id $region; then
        delete_ami $ami_id $region
    else
        echo "Skipping deletion in region $region as AMI $ami_id is not available."
    fi
done
