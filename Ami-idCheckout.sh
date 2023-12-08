!/bin/bash
#
# Check the status of an AWS AMI

# Set your AWS region and AMI ID
#region="$AWS_REGION"
#ami_id="$AWS_AMI_ID"

# Check if the AMI ID is provided
if [ -z "$ami_id" ]; then
    echo "Error: AMI ID is not provided."
    exit 1
fi

# Check the status of the AMI
status=$(aws ec2 describe-images --image-ids $ami_id --region $region --query 'Images[0].State' --output text 2>&1)

# Check if the describe-images command was successful
if [ $? -eq 0 ]; then
    echo "Status of AMI $ami_id in region $region: $status"
else
    echo "Error describing AMI $ami_id in region $region: $status"
fi

    #export AMI_STATUS=$status

