# Battery Monitor with udev Rules

A power-efficient, event-driven battery monitoring system that sends desktop notifications when battery levels change or AC adapter is plugged/unplugged.

## Why udev Rules?

Unlike timer-based solutions that poll battery status every few seconds/minutes, this approach uses **udev rules** which are:

- **Event-driven**: Only triggers when actual battery events occur
- **Instantaneous**: Immediate response to battery state changes  
- **Power efficient**: No background processes consuming CPU/battery
- **Resource efficient**: Zero overhead when nothing is happening

## How It Works

1. **Kernel** detects battery/power supply changes
2. **udev** receives hardware events and matches against rules
3. **Battery script** runs only when events occur
4. **Notifications** sent via `notify-send` (works with swaync/dunst)

## Features

- **Low Battery Warning** (30%) - hourly notifications
- **Critical Battery Warning** (15%) - every 30 minutes
- **Very Critical Warning** (10%) - every 5 minutes
- **Battery Full Notification** (95%) - when charging complete
- **AC Adapter Events** - plug/unplug notifications
- **Smart Throttling** - prevents notification spam
- **State Persistence** - remembers last notification times

## Installation

### Quick Install
```bash
cd ~/.config/scripts
./install-battery-monitor.sh
```

### Manual Installation
1. **Install udev rules**:
   ```bash
   sudo cp 99-battery-monitor.rules /etc/udev/rules.d/
   # Edit the file to replace $USER with your actual username
   sudo nano /etc/udev/rules.d/99-battery-monitor.rules
   sudo udevadm control --reload-rules
   sudo udevadm trigger --subsystem-match=power_supply
   ```

2. **Make script executable**:
   ```bash
   chmod +x battery-monitor.sh
   ```

## Testing

### Test Notifications
```bash
./test-battery-notifications.sh
```

### Test Real Events
- Unplug/plug your charger to test AC adapter notifications
- Monitor udev events: `udevadm monitor --subsystem-match=power_supply`
- Check logs: `journalctl -f | grep battery`

### Manual Test
```bash
./battery-monitor.sh
```

## Configuration

Edit `battery-monitor.sh` to customize:

```bash
# Thresholds (percentages)
LOW_THRESHOLD=30
CRITICAL_THRESHOLD=15
VERY_CRITICAL_THRESHOLD=10
FULL_THRESHOLD=95

# Notification intervals (seconds)
low_interval=3600      # 1 hour for low battery
critical_interval=1800 # 30 minutes for critical
very_critical_interval=300 # 5 minutes for very critical
```

## Files

- `battery-monitor.sh` - Main monitoring script
- `99-battery-monitor.rules` - udev rules template
- `install-battery-monitor.sh` - Installation script
- `test-battery-notifications.sh` - Test suite

## Troubleshooting

### No Notifications
1. Check if notification daemon is running:
   ```bash
   pgrep -f "swaync|dunst"
   ```

2. Test basic notifications:
   ```bash
   notify-send "Test" "Testing notifications"
   ```

3. Check environment variables:
   ```bash
   echo $DISPLAY $WAYLAND_DISPLAY $XDG_RUNTIME_DIR
   ```

### udev Rules Not Working
1. Check if rules are installed:
   ```bash
   ls -la /etc/udev/rules.d/99-battery-monitor.rules
   ```

2. Verify rules syntax:
   ```bash
   sudo udevadm test /sys/class/power_supply/BAT0
   ```

3. Monitor udev events:
   ```bash
   udevadm monitor --environment --udev --subsystem-match=power_supply
   ```

### Script Issues
1. Check script permissions:
   ```bash
   ls -la ~/.config/scripts/battery-monitor.sh
   ```

2. Test script manually:
   ```bash
   ~/.config/scripts/battery-monitor.sh
   ```

3. Check battery paths:
   ```bash
   ls /sys/class/power_supply/
   cat /sys/class/power_supply/BAT*/capacity
   ```

## Uninstallation

```bash
./install-battery-monitor.sh --uninstall
```

Or manually:
```bash
sudo rm /etc/udev/rules.d/99-battery-monitor.rules
sudo udevadm control --reload-rules
rm ~/.cache/battery-monitor-state
```

## Dependencies

- `libnotify-tools` (notify-send)
- `udev` (usually pre-installed)
- `acpi` (optional, for time remaining estimates)

Install on Arch Linux:
```bash
sudo pacman -S libnotify acpi
```

## Integration

Works with:
- **swaync** (SwayNotificationCenter)
- **dunst** (notification daemon)
- **mako** (Wayland notification daemon)
- Any notification daemon supporting `notify-send`

## Advantages over Waybar-only Solution

- **Works in fullscreen**: Notifications appear even when waybar is hidden
- **More detailed info**: Shows time remaining, specific warnings
- **Customizable thresholds**: Not limited to waybar's battery module
- **AC adapter events**: Immediate feedback on plug/unplug
- **Power efficient**: No continuous polling
- **System-wide**: Works regardless of which applications are running