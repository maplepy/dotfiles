#!/bin/bash
# Microphone Fix Script for Lenovo Yoga Pro 9i Gen 10 (83L0)
# This script attempts to fix the "microphone not available" issue
# by forcing the microphone to be enabled and available

set -e

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

# Check if running as root for some operations
check_root() {
    if [[ $EUID -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

log_info "Lenovo Yoga Pro 9i Gen 10 Microphone Fix"
echo "============================================"

# Step 1: Check current microphone status
log_info "Checking current microphone status..."
MIC_STATUS=$(pactl list sources | grep -A 1 "analog-input-mic" | grep "not available" || echo "available")

if [[ "$MIC_STATUS" == *"not available"* ]]; then
    log_warning "Microphone is currently showing as 'not available'"
else
    log_success "Microphone appears to be available"
fi

# Step 2: Check if ALSA utils are installed
if ! command -v amixer >/dev/null 2>&1; then
    log_warning "ALSA utilities not installed. Consider installing: sudo pacman -S alsa-utils"
fi

# Step 3: Force enable microphone in ALSA (if available)
if command -v amixer >/dev/null 2>&1; then
    log_info "Configuring ALSA mixer settings..."

    # Unmute and set capture volume
    amixer -c 0 sset 'Capture' 80% unmute 2>/dev/null || log_warning "Could not set Capture volume"

    # Set microphone boost
    amixer -c 0 sset 'Mic Boost' 2 2>/dev/null || log_warning "Could not set Mic Boost"

    # Enable internal microphone if available
    amixer -c 0 sset 'Internal Mic' unmute 2>/dev/null || true
    amixer -c 0 sset 'Front Mic' unmute 2>/dev/null || true

    log_success "ALSA mixer configured"
else
    log_info "Skipping ALSA mixer configuration (amixer not available)"
fi

# Step 4: Try to force microphone availability via PulseAudio/PipeWire
log_info "Attempting to force enable microphone..."

# Set default source to microphone
pactl set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo 2>/dev/null || log_warning "Could not set default source"

# Unmute the microphone source
pactl set-source-mute alsa_input.pci-0000_00_1f.3.analog-stereo 0 2>/dev/null || log_warning "Could not unmute microphone"

# Set microphone volume to reasonable level
pactl set-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo 80% 2>/dev/null || log_warning "Could not set microphone volume"

# Step 5: Try to activate the microphone port
log_info "Attempting to activate microphone port..."
pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:analog-stereo+input:analog-stereo 2>/dev/null || log_warning "Could not set card profile"

# Step 6: Restart audio services to apply changes
log_info "Restarting audio services..."
systemctl --user restart pipewire pipewire-pulse 2>/dev/null
if [[ $? -eq 0 ]]; then
    log_success "Audio services restarted"
else
    log_warning "Could not restart audio services"
fi

# Give services time to start
sleep 2

# Step 7: Check if microphone is now working
log_info "Checking microphone status after fixes..."

# Check if source exists and is not muted
MIC_EXISTS=$(pactl list sources short | grep "alsa_input.pci-0000_00_1f.3.analog-stereo" || echo "")
if [[ -n "$MIC_EXISTS" ]]; then
    log_success "Microphone source found: $MIC_EXISTS"

    # Check mute status
    MIC_MUTE=$(pactl get-source-mute alsa_input.pci-0000_00_1f.3.analog-stereo 2>/dev/null || echo "unknown")
    if [[ "$MIC_MUTE" == *"no"* ]]; then
        log_success "Microphone is unmuted"
    else
        log_warning "Microphone mute status: $MIC_MUTE"
    fi

    # Check volume
    MIC_VOLUME=$(pactl get-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo 2>/dev/null || echo "unknown")
    log_info "Microphone volume: $MIC_VOLUME"
else
    log_error "Microphone source not found"
fi

# Step 8: Advanced fixes (require root)
if check_root; then
    log_info "Applying advanced fixes (running as root)..."

    # Try to reload audio modules
    modprobe -r snd_hda_intel 2>/dev/null || true
    modprobe snd_hda_intel 2>/dev/null || true

    log_success "Audio modules reloaded"
elif [[ "$1" != "--no-root" ]]; then
    log_info "For advanced fixes, run with sudo:"
    log_info "sudo $0"
fi

# Step 9: Test microphone functionality
log_info "Testing microphone functionality..."

# Try to record a short sample
TEST_FILE="/tmp/mic-test-$(date +%s).wav"
log_info "Recording 2-second test sample to $TEST_FILE"

timeout 2s pactl record --device=alsa_input.pci-0000_00_1f.3.analog-stereo --file-format=wav "$TEST_FILE" 2>/dev/null &
RECORD_PID=$!
sleep 3
kill $RECORD_PID 2>/dev/null || true
wait $RECORD_PID 2>/dev/null || true

if [[ -f "$TEST_FILE" ]] && [[ -s "$TEST_FILE" ]]; then
    FILE_SIZE=$(stat -c%s "$TEST_FILE" 2>/dev/null || echo "0")
    if [[ "$FILE_SIZE" -gt 1000 ]]; then
        log_success "Microphone test recording successful (${FILE_SIZE} bytes)"
        log_info "Test file saved: $TEST_FILE"
        log_info "You can play it back with: paplay $TEST_FILE"
    else
        log_warning "Test recording created but seems empty"
    fi
else
    log_warning "Could not create test recording"
fi

# Step 10: Final status and recommendations
echo ""
log_info "=== FINAL STATUS ==="

# Check current port status
PORT_STATUS=$(pactl list sources | grep -A1 "analog-input-mic" | grep "not available" || echo "available")
if [[ "$PORT_STATUS" == *"not available"* ]]; then
    log_warning "Microphone port still shows as 'not available'"
    echo ""
    log_info "Additional steps you can try:"
    echo "1. Reboot your system to ensure all changes take effect"
    echo "2. Install ALSA utilities: sudo pacman -S alsa-utils"
    echo "3. Check if microphone privacy settings are blocking access"
    echo "4. Try different applications (Discord, browser, etc.) to test microphone"
    echo "5. Check if there's a physical microphone mute button/switch"
    echo ""
    log_info "Even if showing 'not available', the microphone might still work in applications."
else
    log_success "Microphone port is now available!"
fi

# Show current audio setup
log_info "Current audio sources:"
pactl list sources short

echo ""
log_info "Microphone fix script completed!"
log_info "Test your microphone in applications like Discord, Zoom, or browser-based tools."

# Clean up old test files
find /tmp -name "mic-test-*.wav" -mtime +1 -delete 2>/dev/null || true
