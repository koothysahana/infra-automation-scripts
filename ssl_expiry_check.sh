#!/bin/bash

THRESHOLD=15
DOMAIN_FILE="domain.txt"

while read -r domain; do
  echo "Checking $domain..."

  expiry=$(echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null \
           | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

  if [ -z "$expiry" ]; then
    echo "  Could not retrieve SSL expiry date."
    continue
  fi

  expiry_sec=$(date -d "$expiry" +%s)
  now_sec=$(date +%s)
  days_left=$(( (expiry_sec - now_sec) / 86400 ))

  if [ "$days_left" -lt "$THRESHOLD" ]; then
    echo "  ALERT: Expires in $days_left days!"
  else
    echo "  Valid for $days_left more days."
  fi

done < "$DOMAIN_FILE"
