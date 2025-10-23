#!/bin/bash

set -euo pipefail

BACKUP_SRC="/var/lib/jenkins"
BACKUP_DEST="/backup/jenkins"
LOG_DIR="/var/log/jenkins_backup"
LOG_FILE="$LOG_DIR/backup.log"
RETENTION_DAYS=7
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="jenkins_backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DEST" "$LOG_DIR"

echo "[$(date)] Starting Jenkins backup..." >> "$LOG_FILE"

if tar -czf "$BACKUP_DEST/$BACKUP_FILE" -C "$BACKUP_SRC" . 2>>"$LOG_FILE"; then
  echo "[$(date)] Backup successful: $BACKUP_FILE" >> "$LOG_FILE"
else
  echo "[$(date)] ERROR: Backup failed!" >> "$LOG_FILE"
  exit 1
fi

find "$BACKUP_DEST" -type f -mtime +"$RETENTION_DAYS" -name "*.tar.gz" -exec rm -f {} \; 2>>"$LOG_FILE" || true
echo "[$(date)] Old backups older than $RETENTION_DAYS days removed." >> "$LOG_FILE"

echo "[$(date)] Backup completed successfully." >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"
