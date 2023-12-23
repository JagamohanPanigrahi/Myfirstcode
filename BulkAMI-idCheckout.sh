#!/bin/bash

CSV_FILE="$1"
AWS_REGIONS=("us-east-1" "us-west-2" "eu-west-1")  # Add your desired AWS regions to this array

trim() {
    echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

if [ -z "$CSV_FILE" ]; then
    echo "Error: CSV file path is not provided."
    exit 1
fi

shopt -s nocasematch

while IFS= read -r ami_id || [[ -n "$ami_id" ]]; do
    ami_id=$(trim "$ami_id")

    if [ -z "$ami_id" ]; then
        continue
    fi

    if [[ ! "$ami_id" =~ ^ami-[a-fA-F0-9]{8,}$ ]]; then
        echo "Error: Invalid AMI ID format for $ami_id. Skipping...this job"
        exit 1
    else
        success=false

        for region in "${AWS_REGIONS[@]}"; do
            result=$(aws ec2 describe-images --image-ids "$ami_id" --region "$region" \
                     --query 'Images[0].[State,Name]' --output text 2>&1)

            status=$(echo "$result" | awk '{print $1}')
            name=$(echo "$result" | awk '{print $2}')

            if [ "$status" == "available" ]; then
                echo "Status of AMI $ami_id in region $region: $status"
                echo "Name of AMI $ami_id: $name"
                success=true
                break  # Break out of the loop if AMI is found in any region
            fi
        done

        if [ "$success" != true ]; then
            echo "Error describing AMI $ami_id in all regions. AMI State is: $status"
            exit 1
        fi
    fi
done < "$CSV_FILE"
