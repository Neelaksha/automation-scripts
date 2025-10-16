#!/bin/bash
set -euo pipefail
trap 'echo "An error occurred. Exiting."' ERR

# Update PATH to ensure duck is found
export PATH="/opt/local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Local folder to upload
LOCAL_FOLDER="/Users/neelakshabhardwaj/Notes/Study/Study"

# FTP credentials
USERNAME="default"
PASSWORD="default"

# Get the phone's IP address (default gateway when connected to hotspot)
get_phone_ip() {
    route -n get default | awk '/gateway/ { print $2 }'
}
PHONE_IP=$(get_phone_ip)
if [ -z "$PHONE_IP" ]; then
    echo "Could not detect phone IP (default gateway)."
    exit 2
fi

# Check if FTP server is running on port 2221 and immediately report its status
if nc -z "$PHONE_IP" 2221; then
    echo "FTP server is running at $PHONE_IP:2221"
else
    echo "FTP server is NOT running at $PHONE_IP:2221"
    exit 3
fi

# Display current time and phone IP
echo "$(date '+%H:%M') Phone (hotspot) detected at IP: $PHONE_IP"

# Define remote FTP path
REMOTE_URL="ftp://$PHONE_IP:2221/Documents/Notes/Study/Mac"

# Upload using duck
/opt/local/bin/duck --username "$USERNAME" \
    --password "$PASSWORD" \
    --upload "$REMOTE_URL" "$LOCAL_FOLDER" \
    --existing compare \
    --assumeyes
