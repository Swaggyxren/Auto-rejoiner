#!/bin/bash

# Array of package names for Roblox
ROBLOX_PACKAGES=("com.roblox.clienu" "com.roblox.clienv")

# Specify the URL you want to open in Chrome
URL="https://www.roblox.com/share?code=5f31d242dde86a4ba899b5b744f5f5c6&type=Server"

# Roblox URL scheme
ROBLOX_URL="roblox://"

# Discord webhook URL
DISCORD_WEBHOOK_URL="YOUR_DISCORD_WEBHOOK_URL"

# ANSI color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

send_to_discord() {
    MESSAGE="$1"
    curl -H "Content-Type: application/json" -d "{\"content\":\"$MESSAGE\"}" "$DISCORD_WEBHOOK_URL"
}

# Open the URL in Chrome
am start -a android.intent.action.VIEW -d "$URL" com.android.chrome

# Wait for Chrome to open the URL
sleep 5

# Loop through each Roblox package and open it
for PACKAGE in "${ROBLOX_PACKAGES[@]}"; do
    # Get the package name without the '.MainActivity' suffix
    PACKAGE_NAME="${PACKAGE%.*}"
    # Open Roblox app
    am start -a android.intent.action.VIEW -d "$ROBLOX_URL" "$PACKAGE_NAME"
    # Wait for 5 seconds between opening each Roblox app
    sleep 5
done

# Send the completion message to Discord webhook
send_to_discord "All Roblox instances have been opened after visiting the URL in Chrome."

# Wait indefinitely to keep the script running
while true; do
    sleep 3600
done
