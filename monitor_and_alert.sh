#!/bin/bash

# Log file paths
LOG_FILE="/c/Users/USER/infra-automation-scripts/servicemonitoring.log"
LOG_FILE_WIN="C:\\Users\\USER\\infra-automation-scripts\\servicemonitoring.log"

powershell.exe -Command "if (!(Test-Path '$LOG_FILE_WIN')) { New-Item -ItemType File -Path '$LOG_FILE_WIN' | Out-Null }"

# List of services to monitor
SERVICES=("nginx" "MySQL80" "TESTSERVICE")  # TESTSERVICE is for failure testing

# Function to log messages
log_msg() {
    local msg="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" >> "$LOG_FILE"
}

# Function to send email alert via PowerShell
send_email_alert() {
    local service_name="$1"
    powershell.exe -ExecutionPolicy Bypass -File "C:\\Users\\USER\\infra-automation-scripts\\send_alerts.ps1" -service_name "$service_name"
}

log_msg "----- Service Check Started -----"

for service in "${SERVICES[@]}"; do
    # Check if service exists
    sc query "$service" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log_msg "Service $service does not exist!"
        send_email_alert "$service"
        continue
    fi

    # Check service status
    STATUS=$(sc query "$service" | grep "STATE" | awk '{print $4}')
    if [ "$STATUS" = "RUNNING" ]; then
        log_msg "$service is running"
    else
        log_msg "$service is NOT running. Attempting restart..."
        sc start "$service"
        sleep 5
        STATUS_AFTER=$(sc query "$service" | grep "STATE" | awk '{print $4}')
        if [ "$STATUS_AFTER" = "RUNNING" ]; then
            log_msg "$service restarted successfully"
        else
            log_msg "Failed to restart $service!"
            send_email_alert "$service"
        fi
    fi
done

log_msg "----- Service Check Finished -----"
