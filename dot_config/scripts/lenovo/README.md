# Lenovo Yoga Pro 9i Gen 10 (83L0) Audio Fix Documentation

## Overview
This documentation provides solutions for audio issues on the Lenovo Yoga Pro 9i Gen 10, specifically dealing with TAS2781 audio amplifiers that require 2PA (2-Pass Authentication) bypass.

## Problem
- Audio doesn't work out of the box on Linux
- TAS2781 audio amplifiers are protected by 2PA authentication
- Requires I2C communication to bypass the protection and enable audio

## Hardware Details
- **Laptop Model**: 83L0 (Lenovo Yoga Pro 9i Gen 10)
- **Audio IC**: TAS2781 amplifiers
- **I2C Bus**: 16 (Synopsys DesignWare I2C adapter)
- **I2C Addresses**: 0x3f (Left channel), 0x38 (Right channel)

## Available Scripts

### 1. `audio-fix-simple.sh` (Recommended)
**Purpose**: Quick and reliable audio fix
**Usage**: 
```bash
sudo ~/.config/scripts/lenovo/audio-fix-simple.sh
```
**Features**:
- Fast execution
- Hardcoded for your specific hardware
- No unnecessary error messages
- Reliable and tested

### 2. `2pa-byps.sh` (Advanced)
**Purpose**: Auto-detecting version with multiple bus support
**Usage**: 
```bash
sudo ~/.config/scripts/lenovo/2pa-byps.sh [bus_number]
```
**Features**:
- Auto-detects I2C buses
- Supports multiple laptop models
- More verbose output
- Fallback options

### 3. `2pa-byps-optimized.sh`
**Purpose**: Optimized version with better error handling
**Usage**: 
```bash
sudo ~/.config/scripts/lenovo/2pa-byps-optimized.sh
```
**Features**:
- Clean output with success indicators
- Hardware verification
- Optimized for your specific model

## Quick Start Guide

### Option 1: Use the Simple Script (Fastest)
```bash
# Run the audio fix
sudo ~/.config/scripts/lenovo/audio-fix-simple.sh

# Test your audio
pactl list sinks short
```

### Option 2: Use the Fish Alias
```bash
# The alias has been added to your fish config
fix-audio
```

### Option 3: Manual I2C Commands
If scripts don't work, you can run the I2C commands manually:
```bash
# Load I2C module
sudo modprobe i2c-dev

# Configure left channel (0x3f)
sudo i2cset -f -y 16 0x3f 0x00 0x00
sudo i2cset -f -y 16 0x3f 0x7f 0x00
sudo i2cset -f -y 16 0x3f 0x01 0x01
# ... (full sequence in audio-fix-simple.sh)

# Configure right channel (0x38)
sudo i2cset -f -y 16 0x38 0x00 0x00
# ... (full sequence in audio-fix-simple.sh)
```

## Troubleshooting

### Audio Still Not Working?
1. **Restart Audio Services**:
   ```bash
   systemctl --user restart pipewire pipewire-pulse
   ```

2. **Check Audio Devices**:
   ```bash
   pactl list sinks short
   wpctl status
   ```

3. **Verify I2C Bus**:
   ```bash
   ls -la /dev/i2c-*
   i2cdetect -l | grep "Synopsys DesignWare"
   ```

4. **Check Kernel Modules**:
   ```bash
   lsmod | grep i2c
   sudo modprobe i2c-dev
   ```

### Common Issues

#### "No such file or directory" for /dev/i2c-16
**Solution**: Load the I2C module:
```bash
sudo modprobe i2c-dev
```

#### "Write failed" errors
**Cause**: Normal for non-existent addresses
**Solution**: Ignore these errors, they're expected for addresses that don't respond

#### Audio works but volume changes break it
**Solution**: This was fixed with the kernel module configuration:
```bash
# Check if this file exists:
cat /etc/modprobe.d/alsa-base.conf
# Should contain: options snd-intel-dspcfg dsp_driver=1
```

#### Script needs to be run after every reboot
**Solution**: Create a systemd service (advanced users):
```bash
# Create service file (requires sudo)
sudo tee /etc/systemd/system/lenovo-audio-fix.service > /dev/null <<EOF
[Unit]
Description=Lenovo Audio Fix
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/home/maplepy/.config/scripts/lenovo/audio-fix-simple.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl enable lenovo-audio-fix.service
```

## Technical Details

### What the Scripts Do
1. **Load I2C kernel module** (`i2c-dev`)
2. **Configure TAS2781 amplifiers** via I2C commands
3. **Bypass 2PA authentication** using specific register sequences
4. **Enable both left and right audio channels**

### I2C Configuration Sequence
The scripts write specific values to registers on the TAS2781 chips:
- Page selection and reset sequences
- Amplifier configuration
- Channel-specific settings (left vs right have different 0x0a values)
- Power management settings

### Why This Works
- TAS2781 chips have built-in protection (2PA)
- Linux drivers don't handle this authentication properly
- Direct I2C communication bypasses the protection
- Registers are configured to enable audio output

## Files Created/Modified

### New Files
- `~/.config/scripts/lenovo/2pa-byps.sh` - Auto-detecting version
- `~/.config/scripts/lenovo/2pa-byps-optimized.sh` - Optimized version  
- `~/.config/scripts/lenovo/audio-fix-simple.sh` - Simple reliable version
- `~/.config/scripts/lenovo/fix-audio.sh` - Comprehensive version
- `/etc/modprobe.d/alsa-base.conf` - Kernel module configuration

### Modified Files
- `~/.config/fish/config.fish` - Added `fix-audio` alias
- `~/.asoundrc` - Removed (was causing issues)

## Maintenance

### After System Updates
You may need to run the audio fix script again after:
- Kernel updates
- Audio driver updates
- System reboots (sometimes)

### Making it Permanent
The kernel module configuration in `/etc/modprobe.d/alsa-base.conf` should persist across reboots, but the I2C configuration may need to be rerun.

## Credits and References
- Based on community solutions for Lenovo laptops with TAS2781 amplifiers
- Adapted specifically for model 83L0 hardware configuration
- I2C register sequences reverse-engineered from working configurations

## Support
If you encounter issues:
1. Check that your laptop model is 83L0: `cat /sys/class/dmi/id/product_name`
2. Verify I2C buses: `i2cdetect -l`
3. Try the simple script first: `sudo ~/.config/scripts/lenovo/audio-fix-simple.sh`
4. Check audio services: `systemctl --user status pipewire`

## Version History
- v1.0: Initial working version with hardcoded bus 16
- v1.1: Added auto-detection and multiple model support
- v1.2: Optimized version with better error handling
- v1.3: Simple version for reliability