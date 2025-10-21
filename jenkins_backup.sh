#!/bin/bash

BACKUP="$HOME/desktop/assignment/infra-automation-scripts/backups"
JENKINS="$HOME/desktop/assignment/infra-automation-scripts/jenkins_home"
LOG="$HOME/desktop/assignment/infra-automation-scripts/backup.log"

mkdir -p "$BACKUP" "$JENKINS"

cp -r "$JENKINS" "$BACKUP/jenkins_$(date +%Y%m%d)"

find "$BACKUP" -name "jenkins_*" -mtime +7 -exec rm -rf {} \;

echo "Backup done $(date)" >> "$LOG"

