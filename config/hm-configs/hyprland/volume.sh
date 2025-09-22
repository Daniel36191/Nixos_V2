#!/usr/bin/env bash

# Configuration - Add your app rules here
declare -A APP_RULES=(
    # Format: ["window_class"]="device_type:device_name:step"
    ["discord"]="source:Discord-Volume:5"
    ["webcord"]="source:Discord-Volume:5"
    ["vesktop"]="source:Discord-Volume:5"
    ["spotify"]="sink:Spotify-Volume:5"
)

DEFAULT_ACTION="sink:Main-Output:5"  # Default action for all other apps

# Get the active window class
ACTIVE_WINDOW=$(hyprctl activewindow -j 2>/dev/null)
WINDOW_CLASS=$(echo "$(hyprctl activewindow -j 2>/dev/null)" | jq -r '.class' | tr '[:upper:]' '[:lower:]')

# Check if script was called with valid argument
if [[ "$1" != "up" && "$1" != "down" && "$1" != "mute" ]]; then
    echo "Usage: $0 [up|down|mute]"
    exit 1
fi

# Function to get available audio devices (for debugging)
list_audio_devices() {
    echo "Available sinks:"
    wpctl status | grep -A 100 "Sinks:" | grep -oE '[0-9]+\.[[:space:]]+[^ ]+' | head -10
    echo -e "\nAvailable sources:"
    wpctl status | grep -A 100 "Sources:" | grep -oE '[0-9]+\.[[:space:]]+[^ ]+' | head -10
}

# Function to get action for current window
get_action() {
    local class="$1"
    
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
    local device_type=$2  # sink or source
    local device_name=$3
    local step=${4:-5}
    
    if [[ "$direction" == "up" ]]; then
        wpctl set-volume "$device_name" "$step%+"
        notify-send "Volume Control" "$device_type volume ↑ ($device_name)" -t 1000
    elif [[ "$direction" == "down" ]]; then
        wpctl set-volume "$device_name" "$step%-"
        notify-send "Volume Control" "$device_type volume ↓ ($device_name)" -t 1000
    fi
}

# Function to toggle mute
toggle_mute() {
    local device_type=$2  # sink or source
    local device_name=$3
    
    wpctl set-mute "$device_name" toggle
    
    # Get mute status for notification
    local mute_status=$(wpctl get-volume "$device_name" | grep -q "MUTED" && echo "Muted" || echo "Unmuted")
    if [[ "$mute_status" == "Muted" ]]; then
        notify-send "Mute Control" "$device_type muted ($device_name) 🔇" -t 1000
    else
        notify-send "Mute Control" "$device_type unmuted ($device_name) 🔊" -t 1000
    fi
}

# Function to validate device exists
validate_device() {
    local device_name=$1
    local device_type=$2
    
    if [[ "$device_name" == "@DEFAULT_AUDIO_SINK@" || "$device_name" == "@DEFAULT_AUDIO_SOURCE@" ]]; then
        return 0  # Default devices always exist
    fi
    
    if [[ "$device_type" == "sink" ]]; then
        wpctl status | grep "Sinks:" | grep -q "$device_name"
    else
        wpctl status | grep "Sources:" | grep -q "$device_name"
    fi
}

# Main execution
main() {
    local action=$(get_action "$WINDOW_CLASS")
    local action_type=$(echo "$action" | cut -d: -f1)
    local device_name=$(echo "$action" | cut -d: -f2)
    local step_size=$(echo "$action" | cut -d: -f3)
    
    echo "Window: $WINDOW_CLASS, Action: $action_type, Device: $device_name, Step: $step_size, Command: $1"
    
    # Validate device exists, fallback to default if not
    if ! validate_device "$device_name" "$action_type"; then
        echo "Warning: Device '$device_name' not found, using default"
        if [[ "$action_type" == "source" ]]; then
            device_name="@DEFAULT_AUDIO_SOURCE@"
        else
            device_name="@DEFAULT_AUDIO_SINK@"
        fi
    fi
    
    case "$1" in
        "up")
            change_volume "up" "$action_type" "$device_name" "$step_size"
            ;;
        "down")
            change_volume "down" "$action_type" "$device_name" "$step_size"
            ;;
        "mute")
            toggle_mute "mute" "$action_type" "$device_name"
            ;;
    esac
}

# Run main function
main "$1"