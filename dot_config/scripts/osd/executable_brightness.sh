#!/bin/bash

# Consolidated Brightness Control and OSD Script
# Usage: brightness.sh {up|down|show} [step]

ACTION="$1"
STEP="${2:-2}"

# Function to show OSD notification
show_osd() {
    # Get current brightness efficiently
    BRIGHTNESS_PERCENT=$(printf "%.0f" $(brillo -G))

    # Determine icon based on brightness level using waybar's brightness icons
    # Icons: ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"]
    BRIGHTNESS_ICONS=("󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨")
    
    # Calculate icon index based on brightness level (0-10 range)
    ICON_INDEX=$((BRIGHTNESS_PERCENT * 10 / 100))
    if [ "$ICON_INDEX" -gt 10 ]; then
        ICON_INDEX=10
    fi
    
    ICON="${BRIGHTNESS_ICONS[$ICON_INDEX]}"

    TEXT="Brightness: ${BRIGHTNESS_PERCENT}%"

    # Send notification with native progress bar
    notify-send -h string:synchronous:brightness -h int:value:$BRIGHTNESS_PERCENT -t 1500 -u low "$ICON $TEXT"
}

# Handle brightness control
case "$ACTION" in
    "up")
        brillo -qA "$STEP"
        show_osd
        ;;
    "down")
        brillo -qU "$STEP"
        show_osd
        ;;
    "show")
        show_osd
        ;;
    *)
        echo "Usage: $0 {up|down|show} [step]"
        echo "  up/down: Increase/decrease brightness by step% (default: 2%)"
        echo "  show: Show current brightness OSD"
        exit 1
        ;;
esac
