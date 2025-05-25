#!/bin/bash

# Battery Monitor Installation Script
# Installs udev rules and sets up battery monitoring

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
UDEV_RULES_FILE="99-battery-monitor.rules"
UDEV_RULES_PATH="/etc/udev/rules.d/$UDEV_RULES_FILE"
BATTERY_SCRIPT="monitor.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root for udev rules installation
check_privileges() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Do not run this script as root. It will prompt for sudo when needed."
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command -v notify-send >/dev/null 2>&1; then
        missing_deps+=("libnotify-tools")
    fi
    
    if ! command -v udevadm >/dev/null 2>&1; then
        missing_deps+=("udev")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_info "Install them with: sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "All dependencies found"
}

# Check if battery exists
check_battery() {
    print_info "Checking for battery..."
    
    if [ ! -d "/sys/class/power_supply/BAT0" ]; then
        print_error "No battery found at /sys/class/power_supply/BAT0"
        print_info "Available power supplies:"
        ls /sys/class/power_supply/ 2>/dev/null || print_error "No power supplies found"
        exit 1
    fi
    
    print_success "Battery found at /sys/class/power_supply/BAT0"
}

# Create udev rules with correct user path
create_udev_rules() {
    local temp_rules=$(mktemp)
    
    # Replace $env{USER} with actual username in the rules
    sed "s|\$env{USER}|$USER|g" "$SCRIPT_DIR/$UDEV_RULES_FILE" > "$temp_rules"
    
    # Also replace any /home/$USER references to absolute path
    sed -i "s|/home/$USER|$HOME|g" "$temp_rules"
    
    echo "$temp_rules"
}

# Install udev rules
install_udev_rules() {
    print_info "Installing udev rules..."
    
    local temp_rules=$(create_udev_rules)
    
    if sudo cp "$temp_rules" "$UDEV_RULES_PATH"; then
        print_success "Udev rules installed to $UDEV_RULES_PATH"
    else
        print_error "Failed to install udev rules"
        rm -f "$temp_rules"
        exit 1
    fi
    
    rm -f "$temp_rules"
    
    # Set correct permissions
    sudo chmod 644 "$UDEV_RULES_PATH"
    
    # Reload udev rules
    print_info "Reloading udev rules..."
    sudo udevadm control --reload-rules
    sudo udevadm trigger --subsystem-match=power_supply
    
    print_success "Udev rules reloaded"
}

# Install systemd timer
install_systemd_timer() {
    print_info "Installing systemd timer for periodic battery checks..."
    
    if [ -f "$SCRIPT_DIR/battery-monitor.service" ] && [ -f "$SCRIPT_DIR/battery-monitor.timer" ]; then
        # Copy service and timer files to user systemd directory
        mkdir -p "$HOME/.config/systemd/user"
        cp "$SCRIPT_DIR/battery-monitor.service" "$HOME/.config/systemd/user/"
        cp "$SCRIPT_DIR/battery-monitor.timer" "$HOME/.config/systemd/user/"
        
        # Reload systemd user daemon
        systemctl --user daemon-reload
        
        # Enable and start the timer
        systemctl --user enable battery-monitor.timer
        systemctl --user start battery-monitor.timer
        
        print_success "Systemd timer installed and started"
    else
        print_warning "Systemd service/timer files not found, skipping timer installation"
    fi
}

# Test the battery monitor script
test_script() {
    print_info "Testing battery monitor script..."
    
    if [ ! -x "$SCRIPT_DIR/$BATTERY_SCRIPT" ]; then
        print_error "Battery monitor script is not executable"
        chmod +x "$SCRIPT_DIR/$BATTERY_SCRIPT"
        print_success "Made script executable"
    fi
    
    # Test run
    if "$SCRIPT_DIR/$BATTERY_SCRIPT" >/dev/null 2>&1; then
        print_success "Battery monitor script test passed"
    else
        print_warning "Battery monitor script test had issues (this might be normal on first run)"
    fi
}

# Show status
show_status() {
    print_info "Battery Monitor Status:"
    echo "  Script location: $SCRIPT_DIR/$BATTERY_SCRIPT"
    echo "  Udev rules: $UDEV_RULES_PATH"
    echo "  Systemd timer: $(systemctl --user is-enabled battery-monitor.timer 2>/dev/null || echo "not installed")"
    echo "  Timer active: $(systemctl --user is-active battery-monitor.timer 2>/dev/null || echo "inactive")"
    echo "  Current battery: $(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "Unknown")%"
    echo "  Battery status: $(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")"
    echo "  AC adapter: $(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -1 | sed 's/1/Connected/;s/0/Disconnected/' || echo "Unknown")"
}

# Uninstall function
uninstall() {
    print_info "Uninstalling battery monitor..."
    
    # Stop and disable systemd timer
    if systemctl --user is-enabled battery-monitor.timer >/dev/null 2>&1; then
        systemctl --user stop battery-monitor.timer
        systemctl --user disable battery-monitor.timer
        print_success "Stopped and disabled systemd timer"
    fi
    
    # Remove systemd files
    if [ -f "$HOME/.config/systemd/user/battery-monitor.service" ]; then
        rm -f "$HOME/.config/systemd/user/battery-monitor.service"
        rm -f "$HOME/.config/systemd/user/battery-monitor.timer"
        systemctl --user daemon-reload
        print_success "Removed systemd files"
    fi
    
    if [ -f "$UDEV_RULES_PATH" ]; then
        sudo rm -f "$UDEV_RULES_PATH"
        print_success "Removed udev rules"
        
        # Reload udev rules
        sudo udevadm control --reload-rules
        print_success "Reloaded udev rules"
    else
        print_warning "Udev rules file not found"
    fi
    
    # Remove state file
    if [ -f "$HOME/.cache/battery-monitor-state" ]; then
        rm -f "$HOME/.cache/battery-monitor-state"
        print_success "Removed state file"
    fi
    
    print_success "Battery monitor uninstalled"
}

# Test notifications
test_notifications() {
    print_info "Testing notifications..."
    
    # Test basic notification
    if notify-send "Battery Monitor Test" "If you see this, notifications are working!" --urgency=normal --icon=battery 2>/dev/null; then
        print_success "Notification test passed"
    else
        print_error "Notification test failed"
        print_info "Make sure you're running this in a graphical session with notification daemon running"
    fi
}

# Main installation
install() {
    print_info "Installing Battery Monitor..."
    
    check_privileges
    check_dependencies
    check_battery
    test_script
    test_notifications
    install_udev_rules
    install_systemd_timer
    
    print_success "Battery Monitor installed successfully!"
    echo
    show_status
    echo
    print_info "The monitor uses both udev rules and systemd timer:"
    echo "  • udev rules: Immediate AC adapter and charging state changes"
    echo "  • systemd timer: Periodic battery level checks (every 5 minutes)"
    echo
    print_info "Notifications will be sent when:"
    echo "  • Battery drops to 30% (low)"
    echo "  • Battery drops to 15% (critical)"
    echo "  • Battery drops to 10% (very critical)"
    echo "  • Battery reaches 90% while charging (full)"
    echo "  • AC adapter is plugged/unplugged"
    echo
    print_info "To test immediately, try unplugging/plugging your charger"
    print_info "To uninstall: $0 --uninstall"
}

# Help text
show_help() {
    echo "Battery Monitor Installation Script"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  --install       Install battery monitor (default)"
    echo "  --uninstall     Remove battery monitor"
    echo "  --status        Show current status"
    echo "  --test          Test notifications"
    echo "  --help          Show this help"
    echo
    echo "The battery monitor uses udev rules to detect battery events"
    echo "and sends desktop notifications when battery is low, critical,"
    echo "fully charged, or when AC adapter state changes."
}

# Parse command line arguments
case "${1:-}" in
    --uninstall)
        uninstall
        ;;
    --status)
        show_status
        ;;
    --test)
        test_notifications
        ;;
    --help|-h)
        show_help
        ;;
    --install|"")
        install
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac