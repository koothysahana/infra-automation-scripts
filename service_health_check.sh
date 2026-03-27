#!/bin/bash
# Simple Service Health Monitoring Script

SERVICES=("nginx" "mysql")       # services to monitor
LOG_FILE="./service_health.log"  # log file
EMAIL="nivedithaumesh@gmail.com"        # dummy email (for now)

for SERVICE in "${SERVICES[@]}"; do
  # Check if running
  if systemctl is-active --quiet "$SERVICE"; then
    echo "[$(date)] $SERVICE is running" >> "$LOG_FILE"
  else
    echo "[$(date)] $SERVICE is DOWN. Restarting..." >> "$LOG_FILE"
    
    # Attempt restart
    sudo systemctl restart "$SERVICE"

    # Check again
    if systemctl is-active --quiet "$SERVICE"; then
      echo "[$(date)] $SERVICE restarted successfully." >> "$LOG_FILE"
    else
      echo "[$(date)] $SERVICE FAILED to restart!" >> "$LOG_FILE"
      # (Optional: send email here)
    fi
  fi
done

