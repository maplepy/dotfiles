#!/bin/bash

# Toggle NVIDIA GPU between Adaptive (power-saving, default) and
# Prefer Maximum Performance (locks clocks high, avoids ramp-up
# stutter when compositing/decoding demanding video). Live only,
# no reboot needed; resets to Adaptive on next boot.
#
# ponytail: GPUPowerMizerMode is write-only on this driver (always
# reads back 0), so state is tracked via marker file instead of
# querying nvidia-settings. Ceiling: state file can drift from
# reality if GPUPowerMizerMode is changed by other tools; delete
# the marker file to resync to "adaptive".

STATE_FILE="/tmp/gpu-perf-mode"

if [ -f "$STATE_FILE" ]; then
    nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=0' >/dev/null
    rm -f "$STATE_FILE"
    notify-send "GPU Perf Mode" "Adaptive (power-saving)"
else
    nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1' >/dev/null
    touch "$STATE_FILE"
    notify-send "GPU Perf Mode" "Max Performance (higher heat/power)"
fi
