#!/bin/bash

# Name of the game process to monitor
GAME_PROCESS="com.roblox.client"

# URL to access when the game process is not found
TARGET_URL="https://www.roblox.com/games/17017769292/Anime-Defenders-RAIDS?gameSearchSessionInfo=ea560cc2-896c-4a57-ba53-b12d4c4085a3&isAd=false&nativeAdData=&numberOfLoadedTiles=40&page=searchPage&placeId=17017769292&position=0&universeId=5836869368"

# Function to check the process and act
check_process() {
    if pgrep -x "$GAME_PROCESS" > /dev/null; then
        echo "Game process is running..."
    else
        echo "Game process is not running. Accessing the URL..."
        # Access the URL using curl
        curl -X GET "$TARGET_URL"
        # Optionally, break the loop if you only want to run it once when the process is gone
        break
    fi
}

# Ensure we're running as root
if [ "$EUID" -ne 0 ]; then
    echo "Switching to root..."
    tsu -c "$0"
    exit
fi

# Infinite loop to keep checking the process
while true; do
    check_process
    # Sleep for a while before checking again
    sleep 60
done
