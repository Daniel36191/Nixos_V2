#!/bin/bash

# Simple one-time Boox screenshot inverter
TARGET_DIR="$HOME/Pictures/boox"
mkdir -p "$TARGET_DIR"
rm "$TARGET_DIR"/*

echo "Looking for latest screenshot..."

# Check if device is connected
if ! adb devices | grep -q "device$"; then
    echo "Error: No device connected"
    exit 1
fi

# Get the most recent screenshot file
latest_file=$(adb shell "ls -t /sdcard/Pictures/Screenshots/*.png 2>/dev/null | head -1" | tr -d '\r')

if [ -z "$latest_file" ]; then
    echo "No screenshots found"
    exit 0
fi

# Get filename
bn=$(basename "$latest_file")
local_file="$TARGET_DIR/$bn"
inverted_file="$TARGET_DIR/inverted_$bn"

# Skip if we already processed this file
if [ -f "$inverted_file" ]; then
    echo "Already processed: $bn"
    exit 0
fi

echo "Processing: $bn"

# Copy the file
echo "Copying..."
adb pull "$latest_file" "$TARGET_DIR/"

if [ ! -f "$local_file" ]; then
    echo "Error: Failed to copy file"
    exit 1
fi

# Invert colors
echo "Inverting colors..."
ffmpeg -i "$local_file" -vf "negate" "$inverted_file" -y 2>/dev/null

if [ ! -f "$inverted_file" ]; then
    echo "Error: Failed to invert image"
    rm -f "$local_file"
    exit 1
fi

# Clean up
rm "$local_file"
adb shell "rm '$latest_file'"

echo "✓ Successfully created: inverted_$bn"
