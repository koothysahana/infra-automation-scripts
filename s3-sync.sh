#!/bin/bash
LOCAL_FOLDER=$1
BUCKET_NAME=$2

if [ -z "$LOCAL_FOLDER" ] || [ -z "$BUCKET_NAME" ]; then
  echo " Usage: $0 <local-folder> <bucket-name>"
  echo "Example: ./s3-sync.sh myfolder my-s3-bucket"
  exit 1
fi

echo " Upload from '$LOCAL_FOLDER' to bucket '$BUCKET_NAME'"

aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled
echo " Versioning is ON to protect  old files."

aws s3 sync "$LOCAL_FOLDER" "s3://$BUCKET_NAME"
echo " All files uploaded successfully to S3!"

