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

# Function to show Mic OSD notification
show_mic_osd() {
    MIC_OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
    if [[ $MIC_OUTPUT == *"MUTED"* ]]; then
        MIC_MUTE_STATUS="MUTED"
        MIC_VOLUME_DECIMAL=$(echo "$MIC_OUTPUT" | grep -o '[0-9.]\+' | head -1)
    else
        MIC_MUTE_STATUS=""
        MIC_VOLUME_DECIMAL=$(echo "$MIC_OUTPUT" | grep -o '[0-9.]\+')
    fi
    MIC_VOLUME_PERCENT=$(awk "BEGIN {printf \"%.0f\", $MIC_VOLUME_DECIMAL * 100}")
    if [ "$MIC_MUTE_STATUS" = "MUTED" ] || [ "$MIC_VOLUME_PERCENT" -eq 0 ]; then
        ICON_NAME="microphone-sensitivity-muted"
        TEXT="Mic Muted"
        MIC_VOLUME_PERCENT=0
    else
        ICON_NAME="microphone-sensitivity-high"
        TEXT="Mic: ${MIC_VOLUME_PERCENT}%"
    fi
    notify-send -i "$ICON_NAME" -h string:synchronous:mic -h int:value:$MIC_VOLUME_PERCENT -h boolean:transient:true -t 1500 -u low "$TEXT"
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
    "mic"|"mic-toggle")
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        show_mic_osd
        ;;
    "mic-up")
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "${STEP}%+"
        show_mic_osd
        ;;
    "mic-down")
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "${STEP}%-"
        show_mic_osd
        ;;
    *)
        echo "Usage: $0 {up|down|mute|show|mic|mic-up|mic-down} [step]"
        echo "  up/down: Increase/decrease volume by step% (default: 2%)"
        echo "  mute: Toggle mute status"
        echo "  show: Show current volume OSD"
        echo "  mic: Toggle mic mute status"
        echo "  mic-up/mic-down: Increase/decrease mic volume by step% (default: 2%)"
        exit 1
        ;;
esac
