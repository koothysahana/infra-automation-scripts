#!/bin/bash

LOCAL_FOLDER="./folder"
S3_BUCKET="s3://manjula-project-bucket"
LOGFILE="./s3-sync.log"

read -p "Are you sure you want to sync and potentially overwrite files in S3? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Sync cancelled."
    exit 0
fi

echo "Sync started at $(date)" >> "$LOGFILE"
echo "Syncing $LOCAL_FOLDER to $S3_BUCKET ..."

aws s3 sync "$LOCAL_FOLDER" "$S3_BUCKET" --exact-timestamps --delete >> "$LOGFILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Sync completed successfully at $(date)" >> "$LOGFILE"
    echo "Sync completed successfully!"
else
    echo "Sync failed at $(date)" >> "$LOGFILE"
    echo "Sync failed!"
    exit 1
fi
