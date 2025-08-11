#!/bin/bash

# Battery Monitor Script for udev events
# Optimized for event-driven notifications

# Debug logging
LOG_FILE="$HOME/.cache/battery-monitor-debug.log"
debug_log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

debug_log "=== Battery monitor script started ==="
debug_log "PWD: $(pwd)"
debug_log "USER: ${USER:-unknown}"
debug_log "DISPLAY: ${DISPLAY:-unset}"
debug_log "WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-unset}"
debug_log "XDG_RUNTIME_DIR: ${XDG_RUNTIME_DIR:-unset}"

# Configuration
# Dynamically detect the correct BAT* directory
detect_battery_dir() {
    for dir in /sys/class/power_supply/BAT*; do
        if [ -d "$dir" ]; then
            echo "$dir"
            return 0
        fi
    done
    return 1
}
BATTERY_PATH="$(detect_battery_dir)"
AC_PATH="/sys/class/power_supply/AC0"
STATE_FILE="$HOME/.cache/battery-monitor-state"
LOCK_FILE="/tmp/battery-monitor-$USER.lock"

# Thresholds (percentages)
LOW_THRESHOLD=30
CRITICAL_THRESHOLD=15
VERY_CRITICAL_THRESHOLD=10
FULL_THRESHOLD=90

# Notification settings
LOW_URGENCY="normal"
CRITICAL_URGENCY="critical"
FULL_URGENCY="low"

# Create cache directory if it doesn't exist
mkdir -p "$(dirname "$STATE_FILE")"

# Lock mechanism to prevent multiple instances
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    exit 1
fi

# Function to send notification with swaync support
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="$3"
    local icon="$4"

    debug_log "Attempting to send notification: $title - $message"

    # Set DISPLAY and WAYLAND_DISPLAY for notifications to work
    export DISPLAY="${DISPLAY:-:0}"
    export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

    debug_log "Environment: DISPLAY=$DISPLAY, WAYLAND_DISPLAY=$WAYLAND_DISPLAY, XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"

    if command -v notify-send >/dev/null 2>&1; then
        debug_log "notify-send found, sending notification"
        if notify-send \
            --urgency="$urgency" \
            --icon="$icon" \
            --category="device.battery" \
            --app-name="Battery Monitor" \
            --expire-time=10000 \
            "$title" "$message" 2>&1; then
            debug_log "Notification sent successfully"
        else
            debug_log "Failed to send notification"
        fi
    else
        debug_log "notify-send not found"
    fi
}

# Function to get battery info
get_battery_info() {
    local capacity=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "0")
    local status=$(cat "$BATTERY_PATH/status" 2>/dev/null || echo "Unknown")
    local ac_online=$(cat "$AC_PATH/online" 2>/dev/null || echo "0")
    echo "$capacity $status $ac_online"
}

# Function to get time remaining
get_time_remaining() {
    if command -v acpi >/dev/null 2>&1; then
        local time_info=$(acpi -b 2>/dev/null | grep -o '[0-9][0-9]:[0-9][0-9]' | head -1)
        if [ -n "$time_info" ]; then
            echo " ($time_info remaining)"
        fi
    fi
}

# Function to read previous state
read_state() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "0 Unknown 0 0 0 0 0 0"
    fi
}

# Function to write current state
write_state() {
    echo "$1 $2 $3 $4 $5 $6 $7 $8" > "$STATE_FILE"
}

# Main logic
main() {
    debug_log "=== Main function started ==="
    local battery_info=$(get_battery_info)
    local current_capacity=$(echo $battery_info | cut -d' ' -f1)
    local current_status=$(echo $battery_info | cut -d' ' -f2)
    local ac_online=$(echo $battery_info | cut -d' ' -f3)

    debug_log "Battery info: capacity=$current_capacity, status=$current_status, ac_online=$ac_online"

    local state=$(read_state)
    local prev_capacity=$(echo $state | cut -d' ' -f1)
    local prev_status=$(echo $state | cut -d' ' -f2)
    local prev_ac=$(echo $state | cut -d' ' -f3)
    local last_low=$(echo $state | cut -d' ' -f4)
    local last_critical=$(echo $state | cut -d' ' -f5)
    local last_very_critical=$(echo $state | cut -d' ' -f6)
    local last_full=$(echo $state | cut -d' ' -f7)
    local last_charging=$(echo $state | cut -d' ' -f8)

    local current_time=$(date +%s)

    # Convert "never" to 0 for calculations
    [ "$last_low" = "never" ] && last_low=0
    [ "$last_critical" = "never" ] && last_critical=0
    [ "$last_very_critical" = "never" ] && last_very_critical=0
    [ "$last_full" = "never" ] && last_full=0
    [ "$last_charging" = "never" ] && last_charging=0

    # Notification intervals (seconds)
    local low_interval=3600      # 1 hour for low battery
    local critical_interval=1800 # 30 minutes for critical
    local very_critical_interval=300 # 5 minutes for very critical
    local full_interval=3600     # 1 hour for full battery
    local charging_interval=1800 # 30 minutes for charging started

    # Very critical battery (immediate danger)
    if [ "$current_capacity" -le "$VERY_CRITICAL_THRESHOLD" ] && [ "$current_status" = "Discharging" ]; then
        if [ $((current_time - last_very_critical)) -gt $very_critical_interval ]; then
            local time_remaining=$(get_time_remaining)
            send_notification \
                "⚠️ BATTERY CRITICAL!" \
                "Battery at ${current_capacity}%${time_remaining}. System may shutdown soon! PLUG IN NOW!" \
                "$CRITICAL_URGENCY" \
                "battery-caution"
            last_very_critical=$current_time
        fi

    # Critical battery notification
    elif [ "$current_capacity" -le "$CRITICAL_THRESHOLD" ] && [ "$current_status" = "Discharging" ]; then
        if [ $((current_time - last_critical)) -gt $critical_interval ]; then
            local time_remaining=$(get_time_remaining)
            send_notification \
                "🔋 Critical Battery Warning" \
                "Battery level is critically low at ${current_capacity}%${time_remaining}. Please plug in your charger!" \
                "$CRITICAL_URGENCY" \
                "battery-caution"
            last_critical=$current_time
        fi

    # Low battery notification
    elif [ "$current_capacity" -le "$LOW_THRESHOLD" ] && [ "$current_status" = "Discharging" ]; then
        if [ $((current_time - last_low)) -gt $low_interval ]; then
            local time_remaining=$(get_time_remaining)
            send_notification \
                "🔋 Low Battery" \
                "Battery level is low at ${current_capacity}%${time_remaining}. Consider plugging in your charger." \
                "$LOW_URGENCY" \
                "battery-low"
            last_low=$current_time
        fi
    fi

    # Full battery notification (when charging and reaches full threshold)
    if [ "$current_capacity" -ge "$FULL_THRESHOLD" ] && [ "$current_status" = "Charging" ]; then
        if [ $((current_time - last_full)) -gt $full_interval ]; then
            send_notification \
                "🔋 Battery Full" \
                "Battery is fully charged at ${current_capacity}%. You can unplug the charger." \
                "$FULL_URGENCY" \
                "battery-full-charged"
            last_full=$current_time
        fi
    fi

    # Charging started notification (AC plugged in)
    if [ "$ac_online" = "1" ] && [ "$prev_ac" = "0" ] && [ "$current_capacity" -lt "$FULL_THRESHOLD" ]; then
        if [ $((current_time - last_charging)) -gt $charging_interval ]; then
            send_notification \
                "🔌 Charging Started" \
                "Power adapter connected. Battery charging: ${current_capacity}%" \
                "$FULL_URGENCY" \
                "battery-charging"
            last_charging=$current_time
        fi
    fi

    # AC unplugged notification (when battery was charging)
    if [ "$ac_online" = "0" ] && [ "$prev_ac" = "1" ]; then
        send_notification \
            "🔌 Power Disconnected" \
            "Running on battery power. Current level: ${current_capacity}%" \
            "$LOW_URGENCY" \
            "battery"
    fi

    # Write current state
    write_state "$current_capacity" "$current_status" "$ac_online" "$last_low" "$last_critical" "$last_very_critical" "$last_full" "$last_charging"
    debug_log "=== Main function completed ==="
}

# Run main function
main "$@"

# Release lock
flock -u 200
