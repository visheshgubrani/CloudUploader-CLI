#!/bin/bash

# Display a menu and prompt the user for thier choice 

if ! command -v aws &> /dev/null
then
    echo "aws could not be found"
    exit
fi



echo "Select an option:"
echo "1. Create a new Bucket"
echo "2. Upload the file to the exisiting bucket"
read -p "Enter the number of your choice: " choice

# Function to create a new bucket

function new_bucket() {
    read -p "Enter the name of the bucket: " new_bucket_name
    read -p "Enter the region you want to create your new bucket in: " new_bucket_region
    aws s3api create-bucket --bucket $new_bucket_name --region $new_bucket_region --create-bucket-configuration LocationConstraint=$new_bucket_region
}

# Function to add the file to the existing bucket

function add_to_existing_bucket() {
    read -p "Enter the name of the bucket: " existing_bucket_name
    if aws s3api head-bucket --bucket "$existing_bucket_name"; then
        read -p "Enter the file name with path to upload to aws s3 bucket: " file
        if [ -f $file ]; then
            aws s3 cp $file s3://$existing_bucket_name/
            if [ $? -eq 0 ]; then
                echo "Upload Sucessful"
            else
                echo "Upload failed"
            fi
        else
            echo "File does not exists"
        fi
    else
        echo "Bucket Does not Exists"
    fi
}

# Check the users choice and perform the corresponding action

case "$choice" in
    1) 
    new_bucket;;
    2) 
    add_to_existing_bucket;;
    *)
    echo "Invalid choice"
    ;;
esac

