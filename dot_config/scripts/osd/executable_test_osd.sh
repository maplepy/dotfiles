#!/bin/bash

# Test script for consolidated OSD notifications

echo "Testing Volume OSD..."
~/.config/scripts/osd/volume.sh show
sleep 2

echo "Testing Brightness OSD..."
~/.config/scripts/osd/brightness.sh show
sleep 2

echo "Testing Volume Controls..."
echo "Volume up..."
~/.config/scripts/osd/volume.sh up
sleep 2

echo "Volume down..."
~/.config/scripts/osd/volume.sh down
sleep 2

echo "Volume mute toggle..."
~/.config/scripts/osd/volume.sh mute
sleep 2

echo "Volume mute toggle (unmute)..."
~/.config/scripts/osd/volume.sh mute
sleep 2

echo "Testing Brightness Controls..."
echo "Brightness up..."
~/.config/scripts/osd/brightness.sh up
sleep 2

echo "Brightness down..."
~/.config/scripts/osd/brightness.sh down
sleep 2

echo "OSD tests completed!"