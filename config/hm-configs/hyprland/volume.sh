#!/usr/bin/env bash

# Configuration - Add your app rules here
declare -A APP_RULES=(
    # Format: ["window_class"]="device_type:device_name:step"
    ["discord"]="source:Discord-Volume:5"
    ["webcord"]="source:Discord-Volume:5"
    ["vesktop"]="source:Discord-Volume:5"
    ["spotify"]="sink:Spotify-Volume:5"
)

DEFAULT_ACTION="sink:@DEFAULT_AUDIO_SINK@:5"  # Default action for all other apps

# Get the active window class properly
ACTIVE_WINDOW=$(hyprctl activewindow -j 2>/dev/null)
if [[ -n "$ACTIVE_WINDOW" ]]; then
    WINDOW_CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class' 2>/dev/null || echo "")
    WINDOW_CLASS=$(echo "$WINDOW_CLASS" | tr '[:upper:]' '[:lower:]')
else
    WINDOW_CLASS=""
fi

# Debug: Print the detected window class
echo "Detected window class: '$WINDOW_CLASS'"

# Check if script was called with valid argument
if [[ "$1" != "up" && "$1" != "down" && "$1" != "mute" ]]; then
    echo "Usage: $0 [up|down|mute]"
    exit 1
fi

# Function to get available audio devices
list_audio_devices() {
    echo "Available sinks:"
    wpctl status | grep -A 100 "Sinks:" | grep -oE '[0-9]+\.[[:space:]]+[^ ]+' | head -10
    echo -e "\nAvailable sources:"
    wpctl status | grep -A 100 "Sources:" | grep -oE '[0-9]+\.[[:space:]]+[^ ]+' | head -10
}

# Function to get action for current window
get_action() {
    local class="$1"
    
    if [[ -z "$class" ]]; then
        echo "$DEFAULT_ACTION"
        return
    fi
    
    # Check if exact match exists
    if [[ -n "${APP_RULES[$class]}" ]]; then
        echo "${APP_RULES[$class]}"
        return
    fi
    
    # Check for partial matches (app* matching)
    for app_pattern in "${!APP_RULES[@]}"; do
        if [[ "$class" == *"$app_pattern"* ]]; then
            echo "${APP_RULES[$app_pattern]}"
            return
        fi
    done
    
    # Return default action if no match found
    echo "$DEFAULT_ACTION"
}

# Function to change volume
change_volume() {
    local direction=$1
    local device_type=$2
    local device_id=$3
    local step=${4:-5}
    
    if [[ "$direction" == "up" ]]; then
        wpctl set-volume "$device_id" "$step%+"
        notify-send "Volume Control" "$device_type volume ↑" -t 1000
    elif [[ "$direction" == "down" ]]; then
        wpctl set-volume "$device_id" "$step%-"
        notify-send "Volume Control" "$device_type volume ↓" -t 1000
    fi
}

# Function to toggle mute
toggle_mute() {
    local device_type=$2
    local device_id=$3
    
    wpctl set-mute "$device_id" toggle
    
    # Get mute status for notification
    if wpctl get-volume "$device_id" 2>/dev/null | grep -q "MUTED"; then
        notify-send "Mute Control" "$device_type muted 🔇" -t 1000
    else
        notify-send "Mute Control" "$device_type unmuted 🔊" -t 1000
    fi
}

# Function to validate device exists and get full device ID
validate_device() {
    local device_name=$1
    local device_type=$2
    
    # Handle default devices
    if [[ "$device_name" == "@DEFAULT_AUDIO_SINK@" ]]; then
        echo "@DEFAULT_AUDIO_SINK@"
        return 0
    elif [[ "$device_name" == "@DEFAULT_AUDIO_SOURCE@" ]]; then
        echo "@DEFAULT_AUDIO_SOURCE@"
        return 0
    fi
    
    # Look for the device by name and extract just the ID number
    if [[ "$device_type" == "sink" ]]; then
        local device_id=$(wpctl status 2>/dev/null | grep -A 100 "Sinks:" | grep "$device_name" | head -1 | awk '{print $1}' | cut -d. -f1)
    else
        local device_id=$(wpctl status 2>/dev/null | grep -A 100 "Sources:" | grep "$device_name" | head -1 | awk '{print $1}' | cut -d. -f1)
    fi
    
    if [[ -n "$device_id" && "$device_id" =~ ^[0-9]+$ ]]; then
        echo "$device_id"
        return 0
    else
        return 1
    fi
}

# Main execution
main() {
    local action=$(get_action "$WINDOW_CLASS")
    local action_type=$(echo "$action" | cut -d: -f1)
    local device_name=$(echo "$action" | cut -d: -f2)
    local step_size=$(echo "$action" | cut -d: -f3)
    
    echo "Action: $action_type, Device: $device_name, Step: $step_size, Command: $1"
    
    # Validate device exists and get the full device ID
    local actual_device=$(validate_device "$device_name" "$action_type")
    if [[ $? -ne 0 ]]; then
        echo "Warning: Device '$device_name' not found, using default"
        if [[ "$action_type" == "source" ]]; then
            actual_device="@DEFAULT_AUDIO_SOURCE@"
        else
            actual_device="@DEFAULT_AUDIO_SINK@"
        fi
    fi
    
    echo "Using device: $actual_device"
    
    case "$1" in
        "up")
            change_volume "up" "$action_type" "$actual_device" "$step_size"
            ;;
        "down")
            change_volume "down" "$action_type" "$actual_device" "$step_size"
            ;;
        "mute")
            toggle_mute "mute" "$action_type" "$actual_device"
            ;;
    esac
}

# Run main function
main "$1"