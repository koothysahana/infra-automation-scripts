#!/bin/bash
#I am working on Jenkins Backup Script which runs daily at 1 AM, keeps 7 days

JENKINS_HOME="./jenkins_data"          
BACKUP_DIR="./jenkins_backups"      
LOG_FILE="./jenkins_backup.log"        
RETENTION_DAYS=7                   

DATE=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="$BACKUP_DIR/jenkins_backup_$DATE.tar.gz"

# Create backup directory if missing
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting Jenkins backup..." >> "$LOG_FILE"

# Create backup (compress jenkins_data folder)
tar -czf "$BACKUP_FILE" "$JENKINS_HOME" 2>>"$LOG_FILE"

# Check backup status
if [ $? -eq 0 ]; then
  echo "[$(date)] Backup successful: $BACKUP_FILE" >> "$LOG_FILE"
else
  echo "[$(date)] Backup FAILED!" >> "$LOG_FILE"
fi

# Delete old backups (older than RETENTION_DAYS)
find "$BACKUP_DIR" -type f -mtime +$RETENTION_DAYS -name "*.tar.gz" -exec rm -f {} \;

echo "[$(date)] Old backups cleaned (older than $RETENTION_DAYS days)." >> "$LOG_FILE"

