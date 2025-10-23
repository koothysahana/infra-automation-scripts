#!/bin/bash



LOCAL_DIR="/d/Devops/GIT/Git/s3-folder"   
BUCKET_NAME="suchith-jeep-buck"          
LOG_FILE="./s3_folder_sync.log"


touch "$LOG_FILE"

echo "===== S3 Folder Sync Started at $(date) =====" >> "$LOG_FILE"


if [ ! -d "$LOCAL_DIR" ]; then
    echo "❌ Local folder $LOCAL_DIR does not exist. Exiting." >> "$LOG_FILE"
    exit 1
fi


echo "Syncing local folder: $LOCAL_DIR with bucket: $BUCKET_NAME" >> "$LOG_FILE"
aws s3 sync "$LOCAL_DIR" "s3://$BUCKET_NAME" --exact-timestamps >> "$LOG_FILE" 2>&1

echo "Sync completed at $(date)" >> "$LOG_FILE"
echo "===================================================" >> "$LOG_FILE"

