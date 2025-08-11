#!/bin/bash

# Test script for battery monitor notifications
# This script simulates different battery conditions to test notifications

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
BATTERY_SCRIPT="$SCRIPT_DIR/monitor.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if battery monitor script exists
if [ ! -f "$BATTERY_SCRIPT" ]; then
    echo "Error: Battery monitor script not found at $BATTERY_SCRIPT"
    exit 1
fi

if [ ! -x "$BATTERY_SCRIPT" ]; then
    echo "Error: Battery monitor script is not executable"
    exit 1
fi

echo "Battery Monitor Test Suite"
echo "========================="
echo

# Test 1: Basic notification test
print_info "Test 1: Basic notification functionality"
if notify-send "🔋 Battery Monitor Test" "Testing notification system..." --urgency=normal --icon=battery 2>/dev/null; then
    print_success "Basic notifications working"
else
    print_warning "Basic notification test failed"
fi
sleep 2

# Test 2: Check current battery status
print_info "Test 2: Current battery status"
# Detect battery directory (BAT0, BAT1, etc.)
detect_battery_dir() {
    for dir in /sys/class/power_supply/BAT*; do
        if [ -d "$dir" ]; then
            echo "$(basename "$dir")"
            return 0
        fi
    done
    return 1
}

BATTERY_DIR=$(detect_battery_dir)

if [ -n "$BATTERY_DIR" ] && [ -f "/sys/class/power_supply/$BATTERY_DIR/capacity" ]; then
    CAPACITY=$(cat /sys/class/power_supply/$BATTERY_DIR/capacity)
    STATUS=$(cat /sys/class/power_supply/$BATTERY_DIR/status)
    AC_STATUS=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -1)

    echo "  Battery: ${CAPACITY}%"
    echo "  Status: $STATUS"
    echo "  AC: $([ "$AC_STATUS" = "1" ] && echo "Connected" || echo "Disconnected")"
    print_success "Battery information accessible"
else
    print_warning "Cannot access battery information"
fi
echo

# Test 3: Run actual battery monitor script
print_info "Test 3: Running battery monitor script"
if "$BATTERY_SCRIPT" 2>/dev/null; then
    print_success "Battery monitor script executed successfully"
else
    print_warning "Battery monitor script had issues"
fi
sleep 1

# Test 4: Test different notification types
print_info "Test 4: Testing different notification urgencies"

notify-send "🔋 Low Battery Test" "This simulates a low battery warning (30%)" \
    --urgency=normal --icon=battery-low 2>/dev/null
sleep 1

notify-send "⚠️ Critical Battery Test" "This simulates a critical battery warning (15%)" \
    --urgency=critical --icon=battery-caution 2>/dev/null
sleep 1

notify-send "🔌 Charging Test" "This simulates charging started notification" \
    --urgency=low --icon=battery-charging 2>/dev/null
sleep 1

notify-send "✅ Full Battery Test" "This simulates battery full notification" \
    --urgency=low --icon=battery-full-charged 2>/dev/null

print_success "Notification type tests completed"
echo

# Test 5: Check udev rules
print_info "Test 5: Checking udev rules installation"
if [ -f "/etc/udev/rules.d/99-battery-monitor.rules" ]; then
    print_success "Udev rules file exists"
    if grep -q "monitor.sh" "/etc/udev/rules.d/99-battery-monitor.rules"; then
        print_success "Udev rules contain battery monitor script reference"
    else
        print_warning "Udev rules may be malformed"
    fi
else
    print_warning "Udev rules not installed (run install script first)"
fi
echo

# Test 6: Check state file functionality
print_info "Test 6: State file functionality"
STATE_FILE="$HOME/.cache/battery-monitor-state"
if [ -f "$STATE_FILE" ]; then
    echo "  State file exists: $STATE_FILE"
    echo "  Contents: $(cat "$STATE_FILE")"
    print_success "State file functional"
else
    print_info "State file will be created on first run"
fi
echo

# Test 7: Environment variables
print_info "Test 7: Environment variables"
echo "  DISPLAY: ${DISPLAY:-not set}"
echo "  WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-not set}"
echo "  XDG_RUNTIME_DIR: ${XDG_RUNTIME_DIR:-not set}"

if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    print_success "Display environment configured"
else
    print_warning "Display environment may not be configured"
fi
echo

echo "Test Summary"
echo "============"
echo "If you saw notifications appear during this test, the system is working correctly."
echo
echo "To test the actual functionality:"
echo "1. Unplug your charger (should trigger AC disconnected notification)"
echo "2. Plug in your charger (should trigger charging notification)"
echo "3. Let battery drain to test thresholds (30%, 15%, 10%)"
echo
echo "Monitor system logs with: journalctl -f | grep battery"
echo "Check udev events with: udevadm monitor --environment --udev --subsystem-match=power_supply"
