#!/bin/bash
BACKUP_DIR="/backup"
JENKINS_DIR="/var/lib/jenkins"
LOG_FILE="/var/log/jenkins_backup.log"

mkdir -p $BACKUP_DIR

BACKUP_FILE="$BACKUP_DIR/jenkins_$(date +%F).tar.gz"

tar -czf $BACKUP_FILE $JENKINS_DIR
find $BACKUP_DIR -type f -mtime +7 -exec rm -f {} \;
echo "$(date): Backup done sucessfully- $BACKUP_FILE" >> $LOG_FILE
