#!/bin/bash
# FILE=$1
BUCKETNAME=$1
# REGION=$3

if aws s3api head-bucket --bucket "$BUCKETNAME"; then
    echo "Exists"
else 
    echo "Does not exists" 
fi
    