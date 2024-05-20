#!/bin/env bash

# Define options for the powermenu
declare -A options=(
    ["lock"]="󰌾"
    ["logout"]="󰗽"
    ["shutdown"]="⏻"
    ["reboot"]="󰑓"
    ["sleep"]="󰒲"
)

# Desired order of menu options
ordered_keys=("lock" "logout" "shutdown" "reboot" "sleep")

# Function to format menu options
format_options() {
    for key in "${ordered_keys[@]}"; do
        echo "${options[$key]}  ${key^}" # Capitalize first letter of key
    done
}

# Get the user's selection via rofi
selected_option=$(format_options | rofi -dmenu \
                                        -i \
                                        -p "Power" \
                                        -config "~/.config/rofi/powermenu.rasi" \
                                        )

# Extract the selected command (e.g., "lock", "logout")
command=$(echo "$selected_option" | awk '{print tolower($2)}')

# Execute the corresponding command based on the selected option
case "$command" in
    "lock")
        /home/$USER/.config/bspwm/scripts/i3lock-fancy/i3lock-fancy.sh
        ;;
    "logout")
        bspc quit
        ;;
    "shutdown")
        systemctl poweroff
        ;;
    "reboot")
        systemctl reboot
        ;;
    "sleep")
        amixer set Master mute
        systemctl suspend
        ;;
    *)
        echo "No match"
        ;;
esac
