#!/bin/bash
# Simple SSL Expiry Check Script

DOMAINS_FILE="domains.txt"
LOG_FILE="ssl_log.txt"

# How many days before expiry to alert
ALERT_DAYS=15

# Get today's date in seconds
TODAY=$(date +%s)

while read domain; do
  # Skip empty lines
  [ -z "$domain" ] && continue

  echo "Checking SSL for $domain ..."

  # Get expiry date using openssl
  EXPIRY_DATE=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null \
    | openssl x509 -noout -enddate | cut -d= -f2)

  if [ -z "$EXPIRY_DATE" ]; then
    echo "❌ Could not fetch SSL info for $domain" | tee -a "$LOG_FILE"
    continue
  fi

  # Convert expiry date to seconds
  EXPIRY_SEC=$(date -d "$EXPIRY_DATE" +%s)
  DAYS_LEFT=$(( ($EXPIRY_SEC - $TODAY) / 86400 ))

  echo "$domain certificate expires in $DAYS_LEFT days (on $EXPIRY_DATE)" | tee -a "$LOG_FILE"

  # If less than 15 days left, alert
  if [ $DAYS_LEFT -le $ALERT_DAYS ]; then
    echo "⚠️ ALERT: $domain SSL certificate will expire soon!" | tee -a "$LOG_FILE"
  fi

  echo "---------------------------------------"

done < "$DOMAINS_FILE"

