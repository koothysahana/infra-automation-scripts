
#!/bin/bash
# Simple Service Monitor

# Services to check
SERVICES=("nginx" "mysql")

# Log file
LOG_FILE="/var/log/service_monitor.log"

# Email for alerts
EMAIL="manjulafru645@gmail.com"

# Loop through each service
for SERVICE in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$SERVICE"; then
        echo "$(date): $SERVICE is running." >> "$LOG_FILE"
    else
        echo "$(date): $SERVICE is NOT running. Restarting..." >> "$LOG_FILE"
        systemctl restart "$SERVICE"
        sleep 3
        if systemctl is-active --quiet "$SERVICE"; then
            echo "$(date): $SERVICE restarted successfully." >> "$LOG_FILE"
        else
            echo "$(date): Failed to restart $SERVICE!" >> "$LOG_FILE"
            echo "ALERT: $SERVICE failed to restart on $(hostname)" | mail -s "Service Alert: $SERVICE Down" "$EMAIL"
        fi
    fi
done
