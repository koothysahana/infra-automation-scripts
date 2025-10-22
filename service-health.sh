#!/bin/bash
LOG="/tmp/service_health.log"
ALERT="sanjanaumesh08@gmail.com"
SERVICES=("nginx" "mariadb")  # Use 'mariadb' on Amazon Linux

echo "=== $(date) - Service Health Check Started ===" >> $LOG

for service in "${SERVICES[@]}"; do
    # Check if service is running
    if systemctl is-active --quiet $service; then
        echo "$service is running" >> $LOG
    else
        echo "$service is NOT running, trying to restart..." >> $LOG
        sudo systemctl restart $service
        sleep 2
        if systemctl is-active --quiet $service; then
            echo "$service restarted successfully" >> $LOG
        else
            echo "Failed to restart $service! Sending alert..." >> $LOG
            echo "$service failed to restart on $(hostname)" | mail -s "$service Alert" $ALERT
        fi
    fi
done

echo "=== $(date) - Service Health Check Completed ===" >> $LOG

