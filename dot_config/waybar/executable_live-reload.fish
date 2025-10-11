#!/usr/bin/env fish

# Waybar Live Reload Script
# Watches config and style files, restarts waybar on changes

# Color definitions
set color_info (set_color cyan)
set color_success (set_color green)
set color_error (set_color red)
set color_warning (set_color yellow)
set color_reset (set_color normal)
set color_highlight (set_color --bold blue)

set config_dir ~/.config/waybar
set waybar_config $config_dir/config.jsonc
set waybar_modules $config_dir/modules.jsonc
set waybar_style $config_dir/style.css
set waybar_colors $config_dir/colors.css

# List of all files to watch
set files_to_watch $waybar_config $waybar_modules $waybar_style $waybar_colors

function reload_waybar
    echo $color_highlight"[WAYBAR] Reloading waybar..."$color_reset
    if pkill -SIGUSR2 waybar
        echo $color_success"[WAYBAR] Reloaded successfully."$color_reset
        return 0
    else
        echo $color_error"[WAYBAR] Reload failed. Is waybar running?"$color_reset
        return 1
    end
end

function restart_waybar
    echo $color_highlight"[WAYBAR] Restarting waybar..."$color_reset
    pkill waybar
    sleep 0.2
    waybar &
    disown
    echo $color_success"[WAYBAR] Restarted."$color_reset
end

if contains -- "-R" $argv
    reload_waybar
    exit $status
end

if contains -- "--restart" $argv
    restart_waybar
    exit 0
end

echo $color_highlight"[INFO] Watching for changes in Waybar config and style files..."$color_reset
echo "  $color_info Config: $waybar_config $color_reset"
echo "  $color_info Modules: $waybar_modules $color_reset"
echo "  $color_info Style: $waybar_style $color_reset"
echo "  $color_info Colors: $waybar_colors $color_reset"
echo ""
echo $color_warning"Tip: Use -R flag to reload once, or --restart to restart waybar"$color_reset

inotifywait -m -e close_write $files_to_watch | while read dir event file
    set changed_file $dir$file
    
    switch $changed_file
        case $waybar_style
            echo $color_info"[CSS] style.css changed: reloading..."$color_reset
            reload_waybar
            
        case $waybar_colors
            echo $color_info"[CSS] colors.css changed: reloading..."$color_reset
            reload_waybar
            
        case $waybar_config $waybar_modules
            echo $color_info"[CONFIG] $file changed: reloading..."$color_reset
            reload_waybar
            
        case '*'
            # Do nothing for other files
    end
end
