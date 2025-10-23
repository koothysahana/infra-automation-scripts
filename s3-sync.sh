#!/bin/bash

LOCAL_FOLDER=~/s3-sync-folder
S3_BUCKET=s3://sanj-destination-bucket

aws s3 sync $LOCAL_FOLDER $S3_BUCKET --exact-timestamps --acl private

echo "Sync completed successfully!"

