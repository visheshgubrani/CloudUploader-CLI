#!/bin/bash

# Check if aws cli is installed
if ! command -v aws &> /dev/null
then
    echo "aws could not be found"
    exit
fi


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
    buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

    if [ $? -eq 0 ]; then
        echo "List of s3 Buckets"
    
        PS3="Select a bucket (Enter the bucket number): "
        select bucket in $buckets; do
            if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(echo $buckets | wc -w) ]; then
                selected_bucket=$bucket
                echo "You selected bucket: $selected_bucket"
                add_files_to_bucket "$selected_bucket"
                break
            fi
        done
    else
        echo "Failed to list s3 Buckets."
    fi

}

# Adding the new files to the bucket

function add_files_to_bucket() {
    read -p "Enter the path to the file(s) you want to upload: " file_path
    file_path=$(eval echo $file_path)
    if [ -f $file_path ]; then
        aws s3 cp $file_path "s3://$1/"
        if [ $? -eq 0 ]; then
            echo "Uploaded $file_path Successfully"
        else 
            echo "Upload failed"
        fi
    else
        echo "File Does not Exists"
    fi
}

# function add_to_existing_bucket() {
#     read -p "Enter the name of the bucket: " existing_bucket_name
#     if aws s3api head-bucket --bucket "$existing_bucket_name"; then
#         read -p "Enter the file name with path to upload to aws s3 bucket: " file
#         file=$(eval echo "$file")
#         if [ -f $file ]; then
#             aws s3 cp $file s3://$existing_bucket_name/ --no-progress | pv -lep -s $(stat -c%s "$file")
#             if [ $? -eq 0 ]; then
#                 echo "Uploaded $file Sucessfully"
#             else
#                 echo "Upload failed"
#             fi
#         else
#             echo "$file does not exists"
#         fi
#     else
#         echo "Bucket Does not Exists"
#     fi
# }


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

