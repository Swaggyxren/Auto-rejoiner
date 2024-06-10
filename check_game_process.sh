#!/bin/bash

# Array of package names for Roblox
ROBLOX_PACKAGES=("com.roblox.clienu" "com.roblox.clienv")

# Specify the URL you want to open
URL="https://www.roblox.com/games/17017769292/Anime-Defenders-RAIDS"

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
        MESSAGE="${TIMESTAMP}: Not all Roblox instances are running. Opening the link in the Roblox app."
        echo -e "${RED}${MESSAGE}${NC}"
        # Open Roblox app using the first package name in the list
        am start -a android.intent.action.VIEW -d "$URL" "${ROBLOX_PACKAGES[0]}"
    fi

    # Send the message to Discord webhook
    send_to_discord "$MESSAGE"

    # Wait for 20 seconds before checking again
    sleep 20
done
