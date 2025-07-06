#!/bin/bash

# Consolidated Volume Control and OSD Script
# Usage: volume.sh {up|down|mute|show} [step]

ACTION="$1"
STEP="${2:-2}"

# Function to show OSD notification
show_osd() {
    # Get current volume and mute status
    VOLUME_OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

    # Parse volume output efficiently
    if [[ $VOLUME_OUTPUT == *"MUTED"* ]]; then
        MUTE_STATUS="MUTED"
        VOLUME_DECIMAL=$(echo "$VOLUME_OUTPUT" | grep -o '[0-9.]\+' | head -1)
    else
        MUTE_STATUS=""
        VOLUME_DECIMAL=$(echo "$VOLUME_OUTPUT" | grep -o '[0-9.]\+')
    fi

    # Convert to percentage
    VOLUME_PERCENT=$(awk "BEGIN {printf \"%.0f\", $VOLUME_DECIMAL * 100}")

    # Determine icon and text based on volume level and mute status
    if [ "$MUTE_STATUS" = "MUTED" ] || [ "$VOLUME_PERCENT" -eq 0 ]; then
        ICON_NAME="audio-volume-muted"
        TEXT="Muted"
        VOLUME_PERCENT=0
    elif [ "$VOLUME_PERCENT" -lt 33 ]; then
        ICON_NAME="audio-volume-low"
        TEXT="Volume: ${VOLUME_PERCENT}%"
    elif [ "$VOLUME_PERCENT" -lt 66 ]; then
        ICON_NAME="audio-volume-medium"
        TEXT="Volume: ${VOLUME_PERCENT}%"
    else
        ICON_NAME="audio-volume-high"
        TEXT="Volume: ${VOLUME_PERCENT}%"
    fi

    # Send notification with native progress bar and an icon
    notify-send -i "$ICON_NAME" -h string:synchronous:volume -h int:value:$VOLUME_PERCENT -h boolean:transient:true -t 1500 -u low "$TEXT"
}

# Handle volume control
case "$ACTION" in
    "up")
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "${STEP}%+"
        show_osd
        ;;
    "down")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
        show_osd
        ;;
    "mute"|"toggle")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        show_osd
        ;;
    "show")
        show_osd
        ;;
    *)
        echo "Usage: $0 {up|down|mute|show} [step]"
        echo "  up/down: Increase/decrease volume by step% (default: 2%)"
        echo "  mute: Toggle mute status"
        echo "  show: Show current volume OSD"
        exit 1
        ;;
esac
