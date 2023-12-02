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
