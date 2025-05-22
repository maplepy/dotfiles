#!/usr/bin/env fish

# Demo script to send multiple notifications with different parameters, including progress bars

# Simple notifications
notify-send -u low "Low Urgency" "This is a low urgency notification."
notify-send -u normal "Normal Urgency" "This is a normal notification."
notify-send -u critical "Critical Urgency" "This is a critical notification!"

# Notification with an icon
notify-send -i dialog-information "With Icon" "This notification has an icon."

# Notification with a custom app name
notify-send -a DemoApp "With App Name" "This notification sets an app name."

# Notification with a long timeout
notify-send -t 10000 "Long Timeout" "This notification will last 10 seconds."

# Notifications with progress bar (value from 0 to 100)
notify-send --hint=int:value:25 "Progress Notification" "Progress: 25%"
notify-send --hint=int:value:50 "Progress Notification" "Progress: 50%"
notify-send --hint=int:value:75 "Progress Notification" "Progress: 75%"
notify-send --hint=int:value:100 "Progress Notification" "Progress complete!"

# Notification with actions (if supported by your notification daemon)
notify-send --action=default,Default --action=secondary,Secondary "With Actions" "Choose an action!" &

# Simple notification
notify-send "Simple Notification" "No extra parameters."
