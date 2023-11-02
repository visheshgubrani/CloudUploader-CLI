#!/bin/bash

# Display a menu and prompt the user for thier choice 

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

# if aws s3api head-bucket --bucket "$BUCKETNAME"; then
#     echo "Exists"
#     if [ -f $FILE ]; then
        
# else 
#     echo "Bucket Does not Exists, Do you want to create the new Bucket?"
#     read answer
#     if [ $answer eq "yes" ]; then
         
# fi
