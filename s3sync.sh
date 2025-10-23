#!/bin/bash

# Local folder to sync
LOCAL_FOLDER="./myfolder"

# S3 bucket
S3_BUCKET="s3://sahana-s3bucket"

# Log file
LOG_FILE="s3sync_log.txt"

# Start log
echo "Starting S3 sync: $(date)" > "$LOG_FILE"

# Sync local folder to S3
aws s3 sync "$LOCAL_FOLDER" "$S3_BUCKET" --exact-timestamps >> "$LOG_FILE" 2>&1

# Log completion
echo "S3 sync completed: $(date)" >> "$LOG_FILE"
