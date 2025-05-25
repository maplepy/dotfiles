#!/bin/bash

# udev wrapper script for battery monitor
# This ensures proper environment for notifications when called from udev

# Set up environment for notifications
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-1
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_SESSION_TYPE=wayland
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# Find the actual user and home directory
REAL_USER=$(who | awk 'NR==1{print $1}')
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# Switch to the correct user context and run the monitor script
exec sudo -u "$REAL_USER" -i \
    DISPLAY="$DISPLAY" \
    WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
    XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
    XDG_SESSION_TYPE="$XDG_SESSION_TYPE" \
    DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
    "$REAL_HOME/.config/scripts/battery/monitor.sh"