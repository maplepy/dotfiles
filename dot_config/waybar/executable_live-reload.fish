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
set themes_dir $config_dir/themes
set waybar_config $config_dir/config.jsonc
set waybar_modules $config_dir/modules.jsonc
set waybar_style $config_dir/style.css
set waybar_colors $config_dir/colors.css
set current_theme_file $config_dir/.current_theme

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

function list_themes
    echo $color_highlight"[THEMES] Available themes:"$color_reset
    if test -d $themes_dir
        for theme in $themes_dir/*.css
            set theme_name (basename $theme .css)
            if test -f $current_theme_file; and test "$theme_name" = (cat $current_theme_file)
                echo "  $color_success→ $theme_name (active)$color_reset"
            else
                echo "    $theme_name"
            end
        end
    else
        echo $color_warning"  No themes directory found. Create $themes_dir/ to store themes."$color_reset
    end
end

function switch_theme
    set theme_name $argv[1]
    
    if test -z "$theme_name"
        echo $color_error"[THEME] Error: No theme name provided."$color_reset
        echo "Usage: ./live-reload.fish --theme THEME_NAME"
        list_themes
        return 1
    end
    
    set theme_file $themes_dir/$theme_name.css
    
    if not test -f $theme_file
        echo $color_error"[THEME] Error: Theme '$theme_name' not found at $theme_file"$color_reset
        list_themes
        return 1
    end
    
    echo $color_highlight"[THEME] Switching to theme: $theme_name"$color_reset
    cp $theme_file $waybar_style
    echo $theme_name > $current_theme_file
    reload_waybar
    echo $color_success"[THEME] Theme '$theme_name' activated!"$color_reset
end

function save_current_theme
    set theme_name $argv[1]
    
    if test -z "$theme_name"
        echo $color_error"[THEME] Error: No theme name provided."$color_reset
        echo "Usage: ./live-reload.fish --save THEME_NAME"
        return 1
    end
    
    mkdir -p $themes_dir
    set theme_file $themes_dir/$theme_name.css
    
    cp $waybar_style $theme_file
    echo $theme_name > $current_theme_file
    echo $color_success"[THEME] Current style saved as '$theme_name' at $theme_file"$color_reset
end

if contains -- "-R" $argv
    reload_waybar
    exit $status
end

if contains -- "--restart" $argv
    restart_waybar
    exit 0
end

if contains -- "--list" $argv
    list_themes
    exit 0
end

if contains -- "--theme" $argv
    set theme_index (contains -i -- "--theme" $argv)
    set theme_name $argv[(math $theme_index + 1)]
    switch_theme $theme_name
    exit $status
end

if contains -- "--save" $argv
    set save_index (contains -i -- "--save" $argv)
    set theme_name $argv[(math $save_index + 1)]
    save_current_theme $theme_name
    exit $status
end

echo $color_highlight"[INFO] Watching for changes in Waybar config and style files..."$color_reset
echo "  $color_info Config: $waybar_config $color_reset"
echo "  $color_info Modules: $waybar_modules $color_reset"
echo "  $color_info Style: $waybar_style $color_reset"
echo "  $color_info Colors: $waybar_colors $color_reset"
if test -f $current_theme_file
    echo "  $color_success Current theme: "(cat $current_theme_file)$color_reset
end
echo ""
echo $color_warning"Available commands:"$color_reset
echo "  -R              Reload waybar once"
echo "  --restart       Restart waybar"
echo "  --list          List available themes"
echo "  --theme NAME    Switch to a theme"
echo "  --save NAME     Save current style as a theme"

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
