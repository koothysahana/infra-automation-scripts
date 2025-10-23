#!/bin/bash

LOCAL_FOLDER=~/s3-sync-directory
S3_BUCKET=s3://nivi-destinationbucket
LOG_FILE=~/s3-sync.log
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Starting S3 sync..." >> $LOG_FILE

aws s3 sync $LOCAL_FOLDER $S3_BUCKET --exact-timestamps --acl private --size-only >> $LOG_FILE 2>&1

if [ $? -eq 0 ]; then
    DATE=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$DATE] Sync completed successfully!" >> $LOG_FILE
    echo "Sync completed successfully!"
else
    DATE=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$DATE] Sync failed!" >> $LOG_FILE
    echo "Sync failed! Check $LOG_FILE for details."
fi
