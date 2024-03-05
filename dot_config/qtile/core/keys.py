# QTile config - shortcuts
# by maplepy

from libqtile.config import Key, KeyChord, Drag, Click
from libqtile.utils import guess_terminal
from libqtile.lazy import lazy

# from core.config import cfg

mod = "mod4"

app_menu = "rofi -modi run,drun,window -show drun -sidebar-mode -show-icons"
emojis_menu = "rofi -modi emoji -show emoji -sidebar-mode -show-icons"
terminal = "kitty"
terminal2 = "alacritty"
browser = "floorp"
browser2 = "mercury-browser -p yep"

@lazy.function
def float_to_front(qtile) -> None:
    """Bring all floating windows of the group to front"""
    for window in qtile.current_group.windows:
        if window.floating:
            window.cmd_bring_to_front()

keys = [
	# Apps
	Key([mod], "d", lazy.spawn(app_menu), desc="Launch app menu"),
	Key([mod], "less", lazy.spawn(emojis_menu), desc="Launch emojis menu"),

	Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
	Key([mod, "shift"], "Return", lazy.spawn(terminal2), desc="Launch terminal"),
	Key([mod], "w", lazy.spawn(browser), desc="Launch browser"),
	Key([mod, "shift"], "w", lazy.spawn(browser2), desc="Launch browser"),

	# Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
	Key([], "Print", lazy.spawn("flameshot gui"), desc="Take a screenshot"),
	Key([mod], "s", lazy.spawn("~/git/scripts/download_video_audio.sh", shell=True), desc="Download a video or audio with yt-dlp and rofi"),
	# Key([], "Print", lazy.spawn("maim --select | xclip -selection clipboard -target image/png", shell=True), desc="Take a screenshot"),

	# Switch between windows
	Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
	Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
	Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
	Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
	Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
	Key([mod], "Tab", lazy.screen.toggle_group(), desc="Toggle between last used workspaces"),

	# Move windows
	Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
	Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
	Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
	Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

	Key([mod], "u", lazy.layout.normalize(), desc="Reset all window sizes"),
	Key([mod], "o", lazy.layout.grow(), desc="Grow window"),
	Key([mod, "control"], "o", lazy.layout.grow_main(), desc="Grow main pane"),
	Key([mod], "i", lazy.layout.shrink(), desc="Shrink window"),
	Key([mod, "control"], "i", lazy.layout.shrink_main(), desc="Shrink main pane"),
	Key([mod], "p", lazy.layout.maximize(), desc="Maximize or minimize window size"),
	Key([mod, "shift"], "space", lazy.layout.flip()),

	# Resize windows
	Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
	Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
	Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
	Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),

	# Window properties
	Key([mod], "F11", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
	Key([mod, "control"], "F11", lazy.window.toggle_maximize(), desc="Toggle maximize"),
	Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
	Key([mod, "control"], "f", float_to_front, desc="Bring floating window to front"),
	# Key([mod], "n", lazy.window.toggle_minimize(), desc="Toggle minimize"),
	# Key([mod], "g", lazy.function(float_to_front), desc="Bring floating window to front"),
	Key([mod], "c", lazy.window.center(), desc="Center window"),
	Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

	# Qtile management
	Key([mod, "control"], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
	Key([mod, "control"], "b", lazy.hide_show_bar(), desc="Toggle bar"),
	Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
	Key([mod, "control", "shift"], "r", lazy.restart, desc="Restart Qtile"),
	Key([mod, "control", "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

	# Backlight
	Key([], "XF86MonBrightnessDown",	lazy.spawn("brillo -qU 2"), desc="Decrease brightness"),
	Key([], "XF86MonBrightnessUp",		lazy.spawn("brillo -qA 2"), desc="Increase brightness"),

	# Volume
	Key([], "XF86AudioMute",		lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Toggle mute"),
	Key([], "XF86AudioLowerVolume",	lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc="Decrease volume"),
	Key([], "XF86AudioRaiseVolume",	lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"), desc="Increase volume"),

	# Media
	Key([], "XF86AudioPlay",		lazy.spawn("playerctl play-pause"), desc="Play/pause media"),
	Key([], "XF86AudioPrev",		lazy.spawn("playerctl previous"), desc="Previous media"),
	Key([], "XF86AudioNext",		lazy.spawn("playerctl next"), desc="Next media"),
	Key([mod], "XF86AudioMute",			lazy.spawn("playerctl play-pause"), desc="Play/pause media"),
	Key([mod], "XF86AudioLowerVolume",	lazy.spawn("playerctl previous"), desc="Previous media"),
	Key([mod], "XF86AudioRaiseVolume",	lazy.spawn("playerctl next"), desc="Next media"),

    Key([mod], "F12", lazy.group["scratchpad"].dropdown_toggle("term")),
]

# Drag floating layouts.
mouse = [
	Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
	Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
	Click([mod], "Button2", lazy.window.bring_to_front()),
]

# def float_to_front(qtile):
# 	"""
# 	Bring all floating windows of the group to front
# 	"""
# 	for window in qtile.currentGroup.windows:
# 		if window.floating:
# 			window.cmd_bring_to_front()
