#!/bin/bash

# Monitor description
MONITOR_DESC="Ancor Communications Inc VG248 G3LMQS013154"

if hyprctl monitors | grep -q "$MONITOR_DESC"; then
    # It is currently enabled, so disable it
    hyprctl keyword monitor "desc:$MONITOR_DESC, disable"
else
    # It is currently disabled (or not found), so enable it
    hyprctl keyword monitor "desc:$MONITOR_DESC, preferred, auto, 1"
fi
