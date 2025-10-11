#!/bin/bash
# Optimized 2PA Bypass Script for Lenovo Yoga Pro 9i Gen 10 (83L0)
# This script bypasses the 2PA (2-Pass Authentication) for TAS2781 audio amplifiers
# Optimized for your specific hardware configuration

export TERM=linux

# Load I2C kernel module
modprobe i2c-dev

# Your laptop model: 83L0 (Lenovo Yoga Pro 9i Gen 10)
laptop_model=$(cat /sys/class/dmi/id/product_name 2>/dev/null || echo "unknown")
echo "Laptop model: $laptop_model"

# Hardcoded configuration for your specific hardware
# Based on testing: Bus 16 works, addresses 0x3f and 0x38 respond
i2c_bus=16
i2c_addr=(0x3f 0x38)

echo "Using I2C bus: $i2c_bus"

# Verify bus exists
if [ ! -e "/dev/i2c-$i2c_bus" ]; then
    echo "Error: /dev/i2c-$i2c_bus does not exist!"
    echo "Make sure i2c-dev module is loaded: sudo modprobe i2c-dev"
    exit 1
fi

echo "Configuring TAS2781 amplifiers..."

count=0
for value in "${i2c_addr[@]}"; do
    val=$((count % 2))
    echo "Configuring amplifier at address 0x$(printf '%02x' $value)"

    # TAS2781 configuration sequence
    i2cset -f -y $i2c_bus $value 0x00 0x00
    i2cset -f -y $i2c_bus $value 0x7f 0x00
    i2cset -f -y $i2c_bus $value 0x01 0x01
    i2cset -f -y $i2c_bus $value 0x0e 0xc4
    i2cset -f -y $i2c_bus $value 0x0f 0x40
    i2cset -f -y $i2c_bus $value 0x5c 0xd9
    i2cset -f -y $i2c_bus $value 0x60 0x10

    # Different configuration for left/right channels
    if [ $val -eq 0 ]; then
        i2cset -f -y $i2c_bus $value 0x0a 0x1e
    else
        i2cset -f -y $i2c_bus $value 0x0a 0x2e
    fi

    i2cset -f -y $i2c_bus $value 0x0d 0x01
    i2cset -f -y $i2c_bus $value 0x16 0x40
    i2cset -f -y $i2c_bus $value 0x00 0x01
    i2cset -f -y $i2c_bus $value 0x17 0xc8
    i2cset -f -y $i2c_bus $value 0x00 0x04
    i2cset -f -y $i2c_bus $value 0x30 0x00
    i2cset -f -y $i2c_bus $value 0x31 0x00
    i2cset -f -y $i2c_bus $value 0x32 0x00
    i2cset -f -y $i2c_bus $value 0x33 0x01

    i2cset -f -y $i2c_bus $value 0x00 0x08
    i2cset -f -y $i2c_bus $value 0x18 0x00
    i2cset -f -y $i2c_bus $value 0x19 0x00
    i2cset -f -y $i2c_bus $value 0x1a 0x00
    i2cset -f -y $i2c_bus $value 0x1b 0x00
    i2cset -f -y $i2c_bus $value 0x28 0x40
    i2cset -f -y $i2c_bus $value 0x29 0x00
    i2cset -f -y $i2c_bus $value 0x2a 0x00
    i2cset -f -y $i2c_bus $value 0x2b 0x00

    i2cset -f -y $i2c_bus $value 0x00 0x0a
    i2cset -f -y $i2c_bus $value 0x48 0x00
    i2cset -f -y $i2c_bus $value 0x49 0x00
    i2cset -f -y $i2c_bus $value 0x4a 0x00
    i2cset -f -y $i2c_bus $value 0x4b 0x00
    i2cset -f -y $i2c_bus $value 0x58 0x40
    i2cset -f -y $i2c_bus $value 0x59 0x00
    i2cset -f -y $i2c_bus $value 0x5a 0x00
    i2cset -f -y $i2c_bus $value 0x5b 0x00

    i2cset -f -y $i2c_bus $value 0x00 0x00
    i2cset -f -y $i2c_bus $value 0x02 0x00

    count=$((count + 1))
    echo "✓ Amplifier 0x$(printf '%02x' $value) configured successfully"
done

echo "✓ 2PA bypass configuration completed successfully!"
echo "Audio amplifiers should now be working properly."

# Optional: Test audio after configuration
echo ""
echo "Test your audio now. If it doesn't work, you may need to:"
echo "1. Restart PipeWire: systemctl --user restart pipewire"
echo "2. Check volume levels in pavucontrol"
echo "3. Try different audio outputs"
