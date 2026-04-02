#!/bin/bash

# === Paths ===

SOURCE_PATH="/c/Users/Manjula/OneDrive/Desktop/infra-automation-scripts/files/jenkinsbkup.sh"

BACKUP_DIR="/c/Users/Manjula/OneDrive/Desktop/infra-automation-scripts/files/backups"

LOG_FILE="/c/Users/Manjula/OneDrive/Desktop/infra-automation-scripts/files/backup.log"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# === Create directories if not exist ===

mkdir -p "$BACKUP_DIR"

mkdir -p "$(dirname "$LOG_FILE")"

# === Run backup and log it ===

echo "[$(date)] Starting backup of $SOURCE_PATH" >> "$LOG_FILE"

tar -czf "$BACKUP_FILE" "$SOURCE_PATH" >> "$LOG_FILE" 2>&1

echo "[$(date)] Backup saved as $BACKUP_FILE" >> "$LOG_FILE"

# === Remove backups older than 7 days ===

find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +7 -exec rm {} \; >> "$LOG_FILE"

echo "[$(date)] Old backups deleted (older than 7 days)" >> "$LOG_FILE"

