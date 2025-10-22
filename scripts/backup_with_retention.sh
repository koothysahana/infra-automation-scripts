#!/bin/bash

# Folder to back up (for now, just a test folder)
SOURCE="sample_data"

# Where to save backups
DEST="backups"

# Log file
LOGFILE="backup.log"

# How many days to keep backups
RETENTION_DAYS=7

# Make folders if they don't exist
mkdir -p "$SOURCE" "$DEST"

# Get current time for backup name
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)

# Backup file name
BACKUP_FILE="$DEST/backup-$TIMESTAMP.tar.gz"

# Write to log
echo "[$(date +'%F %T')] Starting backup..." >> "$LOGFILE"

# Create backup (compress folder)
tar -czf "$BACKUP_FILE" "$SOURCE" >> "$LOGFILE" 2>&1

# Delete old backups (older than 7 days)
find "$DEST" -type f -name "backup-*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "[$(date +'%F %T')] Backup completed: $BACKUP_FILE" >> "$LOGFILE"
echo "------------------------------------------------" >> "$LOGFILE"
