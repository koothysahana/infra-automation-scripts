#!/bin/bash


DOMAINS_FILE="./domains.txt"
LOG_FILE="./ssl_expiry_check.log"
THRESHOLD_DAYS=15


touch "$LOG_FILE"

echo "===== SSL Expiry Check - $(date) =====" >> "$LOG_FILE"

while read -r domain; do
  if [ -z "$domain" ]; then
    continue
  fi

  echo "Checking $domain..." >> "$LOG_FILE"

  expiry_date=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null \
    | openssl x509 -noout -enddate 2>/dev/null \
    | cut -d= -f2)

  if [ -z "$expiry_date" ]; then
    echo "❌ Failed to retrieve SSL certificate for $domain" >> "$LOG_FILE"
    continue
  fi

 
  expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null || date -jf "%b %d %T %Y %Z" "$expiry_date" +%s 2>/dev/null)
  current_epoch=$(date +%s)
  days_left=$(( (expiry_epoch - current_epoch) / 86400 ))

  if [ "$days_left" -lt "$THRESHOLD_DAYS" ]; then
    echo "⚠️ ALERT: SSL certificate for $domain expires in $days_left days!" >> "$LOG_FILE"
  else
    echo "✅ $domain SSL certificate valid for $days_left more days." >> "$LOG_FILE"
  fi
done < "$DOMAINS_FILE"

echo "==============================================" >> "$LOG_FILE"


