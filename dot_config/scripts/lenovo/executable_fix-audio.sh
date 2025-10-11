#!/bin/bash
# Unified Audio Fix Script for Lenovo Yoga Pro 9i Gen 10 (83L0)
# This script fixes audio issues by configuring TAS2781 amplifiers and restarting audio services

set -e  # Exit on any error

export TERM=linux

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (use sudo)"
    exit 1
fi

log_info "Starting audio fix for Lenovo Yoga Pro 9i Gen 10..."

# Step 1: Load necessary kernel modules
log_info "Loading I2C kernel module..."
modprobe i2c-dev
if [[ $? -eq 0 ]]; then
    log_success "I2C module loaded successfully"
else
    log_error "Failed to load I2C module"
    exit 1
fi

# Step 2: Detect hardware
laptop_model=$(cat /sys/class/dmi/id/product_name 2>/dev/null || echo "unknown")
log_info "Detected laptop model: $laptop_model"

# Verify this is the correct model
if [[ "$laptop_model" != "83L0" ]]; then
    log_warning "This script is optimized for model 83L0, but detected: $laptop_model"
    log_warning "Continuing anyway..."
fi

# Step 3: Configure I2C settings
i2c_bus=16
i2c_addr=(0x3f 0x38)

log_info "Using I2C bus: $i2c_bus"

# Verify bus exists
if [[ ! -e "/dev/i2c-$i2c_bus" ]]; then
    log_error "/dev/i2c-$i2c_bus does not exist!"
    log_error "Available I2C buses:"
    ls -la /dev/i2c-* 2>/dev/null || log_error "No I2C buses found"
    exit 1
fi

# Step 4: Configure TAS2781 amplifiers (2PA bypass)
log_info "Configuring TAS2781 audio amplifiers..."

configure_amplifier() {
    local addr=$1
    local channel=$2
    local val=$3

    log_info "Configuring amplifier at address 0x$(printf '%02x' $addr) (${channel})"

    # TAS2781 2PA bypass configuration sequence
    i2cset -f -y $i2c_bus $addr 0x00 0x00
    i2cset -f -y $i2c_bus $addr 0x7f 0x00
    i2cset -f -y $i2c_bus $addr 0x01 0x01
    i2cset -f -y $i2c_bus $addr 0x0e 0xc4
    i2cset -f -y $i2c_bus $addr 0x0f 0x40
    i2cset -f -y $i2c_bus $addr 0x5c 0xd9
    i2cset -f -y $i2c_bus $addr 0x60 0x10

    # Channel-specific configuration
    if [[ $val -eq 0 ]]; then
        i2cset -f -y $i2c_bus $addr 0x0a 0x1e
    else
        i2cset -f -y $i2c_bus $addr 0x0a 0x2e
    fi

    i2cset -f -y $i2c_bus $addr 0x0d 0x01
    i2cset -f -y $i2c_bus $addr 0x16 0x40
    i2cset -f -y $i2c_bus $addr 0x00 0x01
    i2cset -f -y $i2c_bus $addr 0x17 0xc8
    i2cset -f -y $i2c_bus $addr 0x00 0x04
    i2cset -f -y $i2c_bus $addr 0x30 0x00
    i2cset -f -y $i2c_bus $addr 0x31 0x00
    i2cset -f -y $i2c_bus $addr 0x32 0x00
    i2cset -f -y $i2c_bus $addr 0x33 0x01

    i2cset -f -y $i2c_bus $addr 0x00 0x08
    i2cset -f -y $i2c_bus $addr 0x18 0x00
    i2cset -f -y $i2c_bus $addr 0x19 0x00
    i2cset -f -y $i2c_bus $addr 0x1a 0x00
    i2cset -f -y $i2c_bus $addr 0x1b 0x00
    i2cset -f -y $i2c_bus $addr 0x28 0x40
    i2cset -f -y $i2c_bus $addr 0x29 0x00
    i2cset -f -y $i2c_bus $addr 0x2a 0x00
    i2cset -f -y $i2c_bus $addr 0x2b 0x00

    i2cset -f -y $i2c_bus $addr 0x00 0x0a
    i2cset -f -y $i2c_bus $addr 0x48 0x00
    i2cset -f -y $i2c_bus $addr 0x49 0x00
    i2cset -f -y $i2c_bus $addr 0x4a 0x00
    i2cset -f -y $i2c_bus $addr 0x4b 0x00
    i2cset -f -y $i2c_bus $addr 0x58 0x40
    i2cset -f -y $i2c_bus $addr 0x59 0x00
    i2cset -f -y $i2c_bus $addr 0x5a 0x00
    i2cset -f -y $i2c_bus $addr 0x5b 0x00

    i2cset -f -y $i2c_bus $addr 0x00 0x00
    i2cset -f -y $i2c_bus $addr 0x02 0x00

    log_success "Amplifier 0x$(printf '%02x' $addr) (${channel}) configured successfully"
}

# Configure each amplifier
count=0
for addr in "${i2c_addr[@]}"; do
    val=$((count % 2))
    if [[ $val -eq 0 ]]; then
        channel="Left"
    else
        channel="Right"
    fi

    configure_amplifier $addr "$channel" $val
    count=$((count + 1))
done

log_success "All TAS2781 amplifiers configured successfully!"

# Step 5: Get the user who called sudo for audio service restart
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(eval echo ~$REAL_USER)

log_info "Restarting audio services for user: $REAL_USER"

# Restart PipeWire services as the real user
if [[ -n "$SUDO_USER" ]]; then
    sudo -u "$SUDO_USER" systemctl --user restart pipewire pipewire-pulse 2>/dev/null
    if [[ $? -eq 0 ]]; then
        log_success "Audio services restarted successfully"
    else
        log_warning "Failed to restart audio services automatically"
        log_info "Please run manually: systemctl --user restart pipewire pipewire-pulse"
    fi
else
    log_warning "Could not determine real user for audio service restart"
    log_info "Please run manually: systemctl --user restart pipewire pipewire-pulse"
fi

# Step 6: Verify audio configuration
log_info "Verifying audio configuration..."
sleep 2

# Check if audio sinks are available
if command -v pactl >/dev/null 2>&1; then
    AUDIO_SINKS=$(sudo -u "$REAL_USER" pactl list sinks short 2>/dev/null | wc -l)
    if [[ $AUDIO_SINKS -gt 0 ]]; then
        log_success "Audio sinks detected: $AUDIO_SINKS"
    else
        log_warning "No audio sinks detected"
    fi
else
    log_warning "pactl not available for audio verification"
fi

# Final status
echo ""
log_success "Audio fix completed successfully!"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Test your audio with music or video"
echo "2. Adjust volume levels if needed"
echo "3. If audio still doesn't work, try:"
echo "   - Different audio outputs in system settings"
echo "   - Reboot your system"
echo "   - Check pavucontrol for audio devices"
echo ""
echo -e "${GREEN}If this script helped, you can create an alias:${NC}"
echo "echo 'alias fix-audio=\"sudo ~/.config/scripts/lenovo/fix-audio.sh\"' >> ~/.bashrc"
echo ""
echo -e "${YELLOW}Note: You may need to run this script after system updates or reboots${NC}"
