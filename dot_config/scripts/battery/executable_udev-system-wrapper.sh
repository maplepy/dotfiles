#!/bin/bash

# System-level udev wrapper for battery monitoring
# This script runs as root and switches to user context for notifications

LOG_FILE="/tmp/battery-monitor-udev.log"

# Log function
log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

log "=== udev wrapper started ==="
log "Running as user: $(whoami)"
log "Environment: DISPLAY=${DISPLAY:-unset}, XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-unset}"

# Find the active user session
# Try multiple methods to find the active user
ACTIVE_USER=""
ACTIVE_UID=""

# Method 1: Check who is logged in
ACTIVE_USER=$(who | grep -E ':[0-9]+' | head -1 | awk '{print $1}')

# Method 2: Check loginctl if who doesn't work
if [ -z "$ACTIVE_USER" ]; then
    ACTIVE_USER=$(loginctl list-sessions --no-legend | grep -E 'seat0|tty' | head -1 | awk '{print $3}')
fi

# Method 3: Check /run/user directories
if [ -z "$ACTIVE_USER" ]; then
    for uid_dir in /run/user/*; do
        if [ -d "$uid_dir" ]; then
            uid=$(basename "$uid_dir")
            if [ "$uid" != "0" ]; then
                ACTIVE_USER=$(getent passwd "$uid" | cut -d: -f1)
                break
            fi
        fi
    done
fi

# Method 4: Fallback to the first non-root user in /etc/passwd
if [ -z "$ACTIVE_USER" ]; then
    ACTIVE_USER=$(getent passwd | grep -E '^[^:]*:[^:]*:[1-9][0-9][0-9][0-9]:' | head -1 | cut -d: -f1)
fi

ACTIVE_UID=$(id -u "$ACTIVE_USER" 2>/dev/null)

if [ -z "$ACTIVE_USER" ] || [ -z "$ACTIVE_UID" ]; then
    log "No active user found, exiting"
    exit 1
fi

log "Active user: $ACTIVE_USER (UID: $ACTIVE_UID)"

# Get user's home directory
USER_HOME=$(getent passwd "$ACTIVE_USER" | cut -d: -f6)
SCRIPT_PATH="$USER_HOME/.config/scripts/battery/monitor.sh"

log "Script path: $SCRIPT_PATH"

if [ ! -f "$SCRIPT_PATH" ]; then
    log "Script not found at $SCRIPT_PATH"
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    log "Script not executable"
    exit 1
fi

# Set up environment for the user session
export XDG_RUNTIME_DIR="/run/user/$ACTIVE_UID"
export DISPLAY=":0"
export WAYLAND_DISPLAY="wayland-1"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

log "Switching to user $ACTIVE_USER and executing script"

# Execute the script as the active user
exec runuser -l "$ACTIVE_USER" -c "
    export DISPLAY='$DISPLAY'
    export WAYLAND_DISPLAY='$WAYLAND_DISPLAY'
    export XDG_RUNTIME_DIR='$XDG_RUNTIME_DIR'
    export DBUS_SESSION_BUS_ADDRESS='$DBUS_SESSION_BUS_ADDRESS'
    '$SCRIPT_PATH'
"