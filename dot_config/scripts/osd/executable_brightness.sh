#!/bin/bash

# Consolidated Brightness Control and OSD Script
# Usage: brightness.sh {up|down|show} [step]

ACTION="$1"
STEP="${2:-2}"
BACKLIGHT_DEVICE="intel_backlight"

# Function to show OSD notification
show_osd() {
    # If an argument is provided, use it to get the brightness percent
    if [ -n "$1" ]; then
        BRIGHTNESS_PERCENT=$(echo "$1" | grep -oP '\d+(?=%)')
    else
        BRIGHTNESS_PERCENT=$(brightnessctl -d "$BACKLIGHT_DEVICE" -e | grep -oP '\d+(?=%)')
    fi

    # Determine icon based on brightness level using waybar's brightness icons
    BRIGHTNESS_ICONS=("󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨")

    # Calculate icon index based on brightness level (0-10 range)
    ICON_INDEX=$((BRIGHTNESS_PERCENT * 10 / 100))
    if [ "$ICON_INDEX" -gt 10 ]; then
        ICON_INDEX=10
    fi

    ICON="${BRIGHTNESS_ICONS[$ICON_INDEX]}"

    TEXT="Brightness: ${BRIGHTNESS_PERCENT}%"

    # Send notification with native progress bar
    notify-send -h string:synchronous:brightness -h int:value:$BRIGHTNESS_PERCENT -h boolean:transient:true -t 1500 -u low "$ICON $TEXT"
}

# show_osd() {
#     # Get current brightness efficiently
#     BRIGHTNESS_PERCENT=$(printf "%.0f" $(brillo -G))

#     # Determine icon based on brightness level
#     if [ "$BRIGHTNESS_PERCENT" -lt 33 ]; then
#         ICON_NAME="display-brightness-low"
#     elif [ "$BRIGHTNESS_PERCENT" -lt 66 ]; then
#         ICON_NAME="display-brightness-medium"
#     else
#         ICON_NAME="display-brightness-high"
#     fi

#     TEXT="Brightness: ${BRIGHTNESS_PERCENT}%"

#     # Send notification with native progress bar and an icon
#     notify-send -i "$ICON_NAME" -h string:synchronous:brightness -h int:value:$BRIGHTNESS_PERCENT -h boolean:transient:true -t 1500 -u low "$TEXT"
# }


# Handle brightness control
case "$ACTION" in
    "up")
        BRIGHTNESS_OUTPUT=$(brightnessctl -d "$BACKLIGHT_DEVICE" -e set $STEP+%)
        show_osd "$BRIGHTNESS_OUTPUT"
        ;;
    "down")
        BRIGHTNESS_OUTPUT=$(brightnessctl -d "$BACKLIGHT_DEVICE" -e set $STEP-%)
        show_osd "$BRIGHTNESS_OUTPUT"
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
