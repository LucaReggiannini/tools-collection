#!/bin/bash

function show_help() {
    echo "Usage: $0 URL"
    echo "This script extracts the YouTube channel ID from a given URL and generates the RSS feed URL for the channel."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    exit 0
}

if [[ $# -ne 1 ]]; then
    echo "Error: Exactly one argument is required."
    show_help
fi

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
fi

URL="$1"
if ! [[ "$URL" =~ ^https?:// ]]; then
    echo "Error: The URL must start with http:// or https://."
    exit 1
fi

CHANNEL_IDS=$(curl -v --silent "$URL" 2>&1 \
    | pcregrep --buffer-size=100m -o2 '"(externalId|externalChannelId|channelId)":"(.*?)"' | sort -u)

COUNT=$(echo "$CHANNEL_IDS" | wc -l)

if [[ $COUNT -eq 0 || -z "$CHANNEL_IDS" ]]; then
    echo "Error: No channel ID found."
    exit 1
elif [[ $COUNT -eq 1 ]]; then
    echo "https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_IDS"
    exit 0
else
    echo "Error: Multiple channel IDs found. Please verify the input URL."
    echo "Matched IDs:" >&2
    echo "$CHANNEL_IDS" >&2
    exit 1
fi
