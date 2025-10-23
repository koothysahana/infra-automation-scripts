#!/bin/bash

# File containing domains
DOMAIN_FILE="domains.txt"

# Days threshold
THRESHOLD=15

# Loop through each domain
while read DOMAIN; do
    # Skip empty lines
    [ -z "$DOMAIN" ] && continue

    # Get SSL expiry date
    EXPIRY_DATE=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:443" 2>/dev/null \
                  | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

    if [ -z "$EXPIRY_DATE" ]; then
        echo "$DOMAIN: Could not retrieve SSL"
        continue
    fi

    # Calculate days left
    EXPIRY_SECONDS=$(date -d "$EXPIRY_DATE" +%s)
    CURRENT_SECONDS=$(date +%s)
    DAYS_LEFT=$(( (EXPIRY_SECONDS - CURRENT_SECONDS) / 86400 ))

    # Alert if less than threshold
    if [ "$DAYS_LEFT" -le "$THRESHOLD" ]; then
        echo "ALERT! $DOMAIN SSL expires in $DAYS_LEFT days ($EXPIRY_DATE)"
    else
        echo "$DOMAIN SSL OK, $DAYS_LEFT days left"
    fi

done < "$DOMAIN_FILE"
