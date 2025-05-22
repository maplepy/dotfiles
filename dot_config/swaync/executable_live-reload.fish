#!/usr/bin/env fish

# SwayNC Live Reload Script (Improved)
# Watches config and theme files, compiles SCSS, restarts swaync, and sends notification on notifications.css changes

# Color definitions
set color_info (set_color cyan)
set color_success (set_color green)
set color_error (set_color red)
set color_warning (set_color yellow)
set color_reset (set_color normal)
set color_highlight (set_color --bold blue)

set config_dir ~/.config/swaync
set swaync_config $config_dir/config.json
set main_scss_file $config_dir/main.scss
set css_output_file $config_dir/style.css
set notifications_scss $config_dir/_notifications.scss
set control_centre_scss $config_dir/_control-centre.scss
set matugen_scss $config_dir/matugen.scss

# List of all SCSS files to watch
set scss_files_to_watch $main_scss_file $control_centre_scss $notifications_scss $matugen_scss

echo $color_highlight"[INFO] Watching for changes in SwayNC config and SCSS files..."$color_reset
echo "  $color_info Main SCSS: $main_scss_file $color_reset"
echo "  $color_info Notifications SCSS: $notifications_scss $color_reset"
echo "  $color_info Control Centre SCSS: $control_centre_scss $color_reset"
echo "  $color_info Matugen SCSS: $matugen_scss $color_reset"
echo "  $color_info SwayNC Config: $swaync_config $color_reset"

function compile_and_reload
    if sassc $main_scss_file $css_output_file
        echo $color_success"[SCSS] SCSS compiled."$color_reset
        swaync-client -rs
        return 0
    else
        echo $color_error"[SCSS] Compile error."$color_reset
        return 1
    end
end

function send_test_notifications
    echo $color_highlight"[NOTIFICATIONS] Clearing notifications"$color_reset
    swaync-client -c
    echo $color_highlight"[NOTIFICATIONS] Sending test notifications..."$color_reset
    notify-send "SwayNC Test" "Primary notification: styling test"
    notify-send -u normal "SwayNC Test" "Normal urgency notification"
    notify-send -u low "SwayNC Test" "Low urgency notification"
    notify-send -u critical "SwayNC Test" "Critical urgency notification"
    notify-send -i dialog-information "SwayNC Test" "Notification with icon"
    notify-send -a "Spotify" "SwayNC Test" "Notification with app-name override"
    notify-send -h int:value:75 -h string:x-canonical-private-synchronous:progress "SwayNC Test" "Notification with progress bar (75%)"
    notify-send -c "device" "SwayNC Test" "Notification with category 'device'"
    notify-send -t 20000 "SwayNC Test" "Notification with 20s timeout"
    notify-send -h string:desktop-entry:firefox "SwayNC Test" "Notification with desktop-entry hint"
    notify-send -h string:suppress-sound:true "SwayNC Test" "Notification with sound suppressed"
    notify-send -h string:x-canonical-append:1 "SwayNC Test" "Append to existing notification"
end

function show_control_centre
    echo $color_highlight"[CONTROL] Showing control centre (-t)..."$color_reset
    swaync-client -t
end

function reload_config
    echo $color_highlight"[CONFIG] Reloading SwayNC config (-R)..."$color_reset
    swaync-client -R
end

inotifywait -m -e close_write $swaync_config $scss_files_to_watch | while read dir event file
    set changed_file $dir$file

    if test $changed_file = $notifications_scss
        echo $color_info"[SCSS] notifications.scss changed: recompiling and reloading..."$color_reset
        if compile_and_reload
            send_test_notifications
        end

    else if test $changed_file = $control_centre_scss
        echo $color_info"[SCSS] control-centre.scss changed: recompiling and reloading..."$color_reset
        if compile_and_reload
            show_control_centre
        end

    else if test $changed_file = $swaync_config
        reload_config
        send_test_notifications
        # show_control_centre

    else if contains $changed_file $scss_files_to_watch
        echo $color_info"[SCSS] $changed_file changed: recompiling and reloading..."$color_reset
        compile_and_reload
    end
end
