#!/usr/bin/env bash

#!/bin/bash

# Get the active window class
ACTIVE_WINDOW=$(hyprctl activewindow -j)
WINDOW_CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class' | tr '[:upper:]' '[:lower:]')

# Check if script was called with valid argument
if [[ "$1" != "up" && "$1" != "down" && "$1" != "mute" ]]; then
    echo "Usage: $0 [up|down|mute]"
    exit 1
fi

# Function to change volume
change_volume() {
    local direction=$1
    local sink=$2
    local step=${3:-5}
    
    if [[ "$direction" == "up" ]]; then
        pactl set-sink-volume "$sink" "+${step}%"
        notify-send "Volume Control" "System volume ↑" -t 1000
    elif [[ "$direction" == "down" ]]; then
        pactl set-sink-volume "$sink" "-${step}%"
        notify-send "Volume Control" "System volume ↓" -t 1000
    fi
}

# Function to change microphone volume
change_mic_volume() {
    local direction=$1
    local step=${2:-5}
    local mic_source=$(pactl list short sources | grep input | head -n 1 | awk '{print $2}')
    
    if [[ -n "$mic_source" ]]; then
        if [[ "$direction" == "up" ]]; then
            pactl set-source-volume "$mic_source" "+${step}%"
            notify-send "Volume Control" "Microphone volume ↑" -t 1000
        elif [[ "$direction" == "down" ]]; then
            pactl set-source-volume "$mic_source" "-${step}%"
            notify-send "Volume Control" "Microphone volume ↓" -t 1000
        fi
    fi
}

# Function to toggle mute
toggle_mute() {
    local target=$1
    
    if [[ "$target" == "mic" ]]; then
        local mic_source=$(pactl list short sources | grep input | head -n 1 | awk '{print $2}')
        if [[ -n "$mic_source" ]]; then
            pactl set-source-mute "$mic_source" toggle
            
            # Get mute status for notification
            local mute_status=$(pactl get-source-mute "$mic_source" | awk '{print $2}')
            if [[ "$mute_status" == "yes" ]]; then
                notify-send "Microphone Muted" "🎤 Muted" -t 1000
            else
                notify-send "Microphone Unmuted" "🎤 Unmuted" -t 1000
            fi
        fi
    else
        local sink=$(pactl get-default-sink)
        pactl set-sink-mute "$sink" toggle
        
        # Get mute status for notification
        local mute_status=$(pactl get-sink-mute "$sink" | awk '{print $2}')
        if [[ "$mute_status" == "yes" ]]; then
            notify-send "Audio Muted" "🔇 Muted" -t 1000
        else
            notify-send "Audio Unmuted" "🔊 Unmuted" -t 1000
        fi
    fi
}

# Check if Discord is focused (case-insensitive match for various Discord instances)
if [[ "$WINDOW_CLASS" == *"discord"* ]] || [[ "$WINDOW_CLASS" == *"webcord"* ]] || [[ "$WINDOW_CLASS" == *"vesktop"* ]]; then
    echo "Discord focused - controlling microphone"
    
    case "$1" in
        "up")
            change_mic_volume "up" 5
            ;;
        "down")
            change_mic_volume "down" 5
            ;;
        "mute")
            toggle_mute "mic"
            ;;
    esac
else
    echo "Other application focused - controlling system volume"
    
    case "$1" in
        "up")
            change_volume "up" "@DEFAULT_SINK@" 5
            ;;
        "down")
            change_volume "down" "@DEFAULT_SINK@" 5
            ;;
        "mute")
            toggle_mute "system"
            ;;
    esac
fi