#!/usr/bin/env bash

TARGET_DIR="$HOME/Pictures/boox"
mkdir -p "$TARGET_DIR"
rm "$TARGET_DIR"/* 2>/dev/null

if ! adb devices | grep -q "device$"; then
    echo "Error: No device connected"
    exit 1
fi

latest_file=$(adb shell "ls -t /sdcard/Pictures/Screenshots/*.png 2>/dev/null | head -1" | tr -d '\r')

if [ -z "$latest_file" ]; then
    echo "No screenshots found"
    exit 0
fi

bn=$(basename "$latest_file")
local_file="$TARGET_DIR/$bn"
inverted_file="$TARGET_DIR/inverted_$bn"
transparent_file="$TARGET_DIR/transparent_$bn"

adb pull "$latest_file" "$TARGET_DIR/"

if [ ! -f "$local_file" ]; then
    echo "Error: Failed to copy file"
    exit 1
fi

ffmpeg -i "$local_file" -vf "negate" "$inverted_file" -y 2>/dev/null

magick $inverted_file -fuzz 5% -transparent '#000000' $transparent_file

wl-copy < $transparent_file

notify-send -i /home/daniel/.config/hypr/scripts/boox.png "Screenshot Taken"

rm -f "$inverted_file"

## Clean up
rm "$local_file"
adb shell "rm '$latest_file'"

echo "Successfull"
