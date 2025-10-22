#!/bin/bash

BACKUP_DIR="backups"        
JENKINS_DIR="jenkins_data"     
LOG_FILE="jenkins_backup.log"  

# Create backup folder if missing
mkdir -p "$BACKUP_DIR"

# Create backup folder with today's date
TIMESTAMP=$(date +%F)
BACKUP_FOLDER="$BACKUP_DIR/jenkins_backup_$TIMESTAMP"

# Copy the folder
cp -r "$JENKINS_DIR" "$BACKUP_FOLDER"

# Remove old backups 
find "$BACKUP_DIR" -type d -name "jenkins_backup_*" -mtime +7 -exec rm -rf {} \;

# Log message
echo "$(date): Backup done - $BACKUP_FOLDER" >> "$LOG_FILE"

