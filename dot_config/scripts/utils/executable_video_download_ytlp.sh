#!/bin/bash

# Global variables
AUDIO_MODE=false
HEADLESS_MODE=false
URL=""
MAX_RETRIES=1

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --audio)
            AUDIO_MODE=true
            ;;
        --headless)
            HEADLESS_MODE=true
            ;;
    esac
done

# Function to send notifications
send_notification() {
    local type="$1"      # "start", "success", "failure"
    local mode="$2"      # "audio" or "video"
    local url="$3"       # URL for start notifications

    local title=""
    local message=""
    local icon=""
    local urgency=""

    if [[ "$mode" == "audio" ]]; then
        title="Audio Download"
        case "$type" in
            "start")
                message="Starting audio download: $url"
                icon="audio-x-generic"
                ;;
            "success")
                message="Audio download completed successfully!"
                icon="emblem-default"
                ;;
            "failure")
                message="Audio download failed after retry!"
                icon="dialog-error"
                urgency="--urgency=critical"
                ;;
        esac
    else
        title="Video Download"
        case "$type" in
            "start")
                message="Starting video download: $url"
                icon="video-x-generic"
                ;;
            "success")
                message="Video download completed successfully!"
                icon="emblem-default"
                ;;
            "failure")
                message="Video download failed after retry!"
                icon="dialog-error"
                urgency="--urgency=critical"
                ;;
        esac
    fi

    notify-send "$title" "$message" --icon="$icon" $urgency
}

# Function to perform the actual download
perform_download() {
    local url="$1"
    local is_audio="$2"

    if [[ "$is_audio" == true ]]; then
        yt-dlp --config-location ~/.config/yt-dlp/audio-config "$url"
    else
        yt-dlp "$url"
    fi
}

# Function to attempt download with logging
attempt_download() {
    local url="$1"
    local is_audio="$2"
    local attempt_num="$3"

    local mode_text="video"
    [[ "$is_audio" == true ]] && mode_text="audio"

    if [[ "$attempt_num" == "1" ]]; then
        echo "Downloading $mode_text: $url"
        send_notification "start" "$mode_text" "$url"
    else
        echo "Retrying $mode_text download..."
    fi

    if perform_download "$url" "$is_audio"; then
        echo "Download completed successfully!"
        send_notification "success" "$mode_text"
        return 0
    else
        return 1
    fi
}

# Function to get URL from clipboard
get_clipboard_url() {
    wl-paste | grep -Eo 'https?://[^ ]+'
}

# Function to detect download mode when URL is manually entered
detect_download_mode() {
    if [[ "$AUDIO_MODE" == false ]]; then
        echo "Download options:"
        echo "1. Video (default)"
        echo "2. Audio only (MP3)"
        read -p "Choose option (1/2): " OPTION

        if [[ "$OPTION" == "2" ]]; then
            AUDIO_MODE=true
        fi
    fi
}

# Function to get URL from user input
get_user_url() {
    read -p "Enter video URL: " URL

    if [[ -z "$URL" ]]; then
        echo "No URL provided."
        send_notification "failure" "$AUDIO_MODE" "No URL provided."
        return 1
    fi

    detect_download_mode
    return 0
}

# Function to initialize URL (from clipboard or user input)
initialize_url() {
    URL=$(wl-paste | grep -Eo 'https?://[^ ]+')

    if [[ -z "$URL" ]]; then
        if [[ "$HEADLESS_MODE" == true ]]; then
            echo "No URL found in clipboard."
            send_notification "failure" "video" "No URL recognised in clipboard"
            exit 1
        else
            echo "No URL found in clipboard."
            if ! get_user_url; then
                echo "Exiting."
                exit 1
            fi
        fi
    fi
}

# Function to show retry menu and handle user choice
show_retry_menu() {
    echo "----------------------------------------"
    echo "Download failed after automatic retry."
    echo "Options:"
    echo "1. Retry same download"
    echo "2. Enter new URL"
    echo "3. Quit"
    echo "----------------------------------------"

    while true; do
        read -p "Choose option (1/2/3): " CHOICE

        case $CHOICE in
            1)
                echo "Retrying same download..."
                return 0
                ;;
            2)
                echo "Enter new URL:"
                if get_user_url; then
                    echo "Using new URL..."
                    return 0
                else
                    echo "Invalid URL. Please try again."
                    continue
                fi
                ;;
            3)
                echo "Exiting."
                exit 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, or 3."
                continue
                ;;
        esac
    done
}

# Function to handle download with retries
handle_download_with_retries() {
    local attempt=1

    while [[ $attempt -le $((MAX_RETRIES + 1)) ]]; do
        if attempt_download "$URL" "$AUDIO_MODE" "$attempt"; then
            return 0
        fi

        if [[ $attempt -le $MAX_RETRIES ]]; then
            echo "Download failed. Retrying automatically..."
            sleep 2
        fi

        ((attempt++))
    done

    # All attempts failed
    local mode_text="video"
    [[ "$AUDIO_MODE" == true ]] && mode_text="audio"
    send_notification "failure" "$mode_text"

    return 1
}

# Function to run the main download loop
main_download_loop() {
    while true; do
        echo "----------------------------------------"

        if handle_download_with_retries; then
            break
        else
            show_retry_menu
        fi
    done
}

# Function to finalize and exit
finalize() {
    echo "Done. Exiting script."
    if [[ "$AUDIO_MODE" == true ]]; then
        URL="Audio download completed successfully!"
    else
        URL="Video download completed successfully!"
    fi

    send_notification "success" "$AUDIO_MODE" "$URL"
}

# Main execution
initialize_url
main_download_loop
