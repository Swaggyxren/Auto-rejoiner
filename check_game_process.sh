#!/bin/bash

# Array of package names for Roblox
ROBLOX_PACKAGES=("com.roblox.clienu" "com.roblox.clienv")

# Specify the URL you want to open
ROBLOX_URL="https://www.roblox.com/share?code=5f31d242dde86a4ba899b5b744f5f5c6&type=Server"

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

while true; do
    # Get the current timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Count of running Roblox processes
    RUNNING_COUNT=0

    # Check if any of the Roblox processes are running
    for PACKAGE in "${ROBLOX_PACKAGES[@]}"; do
        PROCESS_COUNT=$(pgrep -c -f "$PACKAGE")
        if [ "$PROCESS_COUNT" -gt 0 ]; then
            ((RUNNING_COUNT++))
        fi
    done

    if [ "$RUNNING_COUNT" -eq "${#ROBLOX_PACKAGES[@]}" ]; then
        MESSAGE="${TIMESTAMP}: All Roblox instances are running."
        echo -e "${GREEN}${MESSAGE}${NC}"
    else
        MESSAGE="${TIMESTAMP}: Not all Roblox instances are running. Opening the link in all Roblox apps."
        echo -e "${RED}${MESSAGE}${NC}"
        # Open Roblox app for each package name in the list
        for PACKAGE in "${ROBLOX_PACKAGES[@]}"; do
            am start -a android.intent.action.VIEW -d "$ROBLOX_URL" -n "$PACKAGE/.MainActivity"
        done
    fi

    # Send the message to Discord webhook
    send_to_discord "$MESSAGE"

    # Wait for 20 seconds before checking again
    sleep 20
done
