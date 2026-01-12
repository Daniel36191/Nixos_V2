#!/usr/bin/env bash

SOURCE_DIR="$HOME/Documents/book"
TARGET_DIR="/sdcard/Documents"
NTFY_PIC="$HOME/.config/hypr/icons/sync.png"

check_device() {
    if ! adb devices | grep -q "device$"; then
        notify-send -i $NTFY_PIC "No Device Connected"
        exit 1
    fi
}

push_files() {
    check_device
    
    # Create directory if needed
    adb shell mkdir -p "$TARGET_DIR"
    
    adb pull "$SOURCE_DIR/" "$TARGET_DIR/"
    
    notify-send -i $NTFY_PIC "Pushed"
}

pull_files() {
    check_device
    mkdir -p "$SOURCE_DIR"
    adb pull "$TARGET_DIR/" "$SOURCE_DIR/"
    notify-send -i $NTFY_PIC "Pulled"
}

choice=$(echo -e "Push to Boox\nPull from Boox\nExit" | rofi -dmenu -p "Boox Sync")

case "$choice" in
    "Push to Boox")
        push_files
        ;;
    "Pull from Boox")
        pull_files
        ;;
    "Exit"|*)
        exit 0
        ;;
esac