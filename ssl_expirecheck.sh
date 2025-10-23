#!/bin/bash

DOMAINS_FILE="ssl.sh"
LOG_FILE="ssl_check_log.txt"
ALERT_DAYS=15
TODAY=$(date +%s)

> "$LOG_FILE"

while read -r domain; do
    [[ -z "$domain" ]] && continue

    echo "Checking SSL for $domain ..." | tee -a "$LOG_FILE"

    EXPIRY_DATE=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null \
                  | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

    if [[ -z "$EXPIRY_DATE" ]]; then
        echo "❌ Could not fetch SSL info for $domain" | tee -a "$LOG_FILE"
        echo "---------------------------------------" | tee -a "$LOG_FILE"
        continue
    fi

    EXPIRY_SEC=$(date -d "$EXPIRY_DATE" +%s)
    DAYS_LEFT=$(( (EXPIRY_SEC - TODAY) / 86400 ))

    echo "$domain SSL expires in $DAYS_LEFT days (on $EXPIRY_DATE)" | tee -a "$LOG_FILE"

    if [[ $DAYS_LEFT -le $ALERT_DAYS ]]; then
        echo "ALERT: $domain SSL certificate will expire soon!" | tee -a "$LOG_FILE"
    fi

    echo "---------------------------------------" | tee -a "$LOG_FILE"

done < "$DOMAINS_FILE"

