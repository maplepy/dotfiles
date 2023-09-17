from libqtile.config import Key
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from extras import float_to_front
from utils.config import cfg

if cfg.is_xephyr:
	mod, alt = "mod1", "control"
	restart = lazy.restart()
else:
	mod, alt = "mod4", "mod1"
	restart = lazy.reload_config()

if not cfg.term:
	cfg.term = guess_terminal()
if not cfg.term2:
	cfg.term2 = cfg.term
if not cfg.browser:
	cfg.browser = "firefox"
if not cfg.code:
	cfg.code = "code"

keys = [
	# Focus windows
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

	# Resize windows
	Key([mod, "control"], "Left", lazy.layout.grow(), desc="Grow window to the left"),
	Key([mod, "control"], "Right", lazy.layout.shrink(), desc="Grow window to the right"),
	Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
	Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
	Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
	Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
	Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

	# Window properties
	Key([], "F11", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
	Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
	Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle maximize"),
	# Key([mod], "n", lazy.window.toggle_minimize(), desc="Toggle minimize"),
	Key([mod], "g", lazy.function(float_to_front), desc="Bring floating window to front"),
	Key([mod], "c", lazy.window.center(), desc="Center window"),
	Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

	# Qtile management
	Key([mod, "control"], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
	Key([mod, "control"], "b", lazy.hide_show_bar(), desc="Toggle bar"),
	Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
	Key([mod, "control", "shift"], "r", restart, desc="Restart Qtile"),
	Key([mod, "control", "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

	# Apps
	Key([mod], "d", lazy.spawn("rofi -modi run,drun,window -show drun -sidebar-mode -show-icons"), desc="Launch rofi"),
	Key([mod], "less", lazy.spawn("rofi -modi emoji -show emoji -sidebar-mode -show-icons"), desc="Launch rofi"),
	Key([mod], "Return", lazy.spawn(cfg.term), desc="Launch terminal"),
	Key([mod, "shift"], "Return", lazy.spawn(cfg.term2), desc="Launch terminal"),
	Key([mod], "w", lazy.spawn(cfg.browser), desc="Launch browser"),
	Key([mod], "e", lazy.spawn(cfg.code), desc="Launch code editor"),

	# Screenshot tool
	# Key([], "Print", lazy.spawn("gnome-screenshot -i"), desc="Launch screenshot tool"),

	# Backlight
	Key([], "XF86MonBrightnessDown",	lazy.spawn("brillo -qU 2"), desc="Decrease brightness"),
	Key([], "XF86MonBrightnessUp",		lazy.spawn("brillo -qA 2"), desc="Increase brightness"),

	# Volume
	Key([], "XF86AudioMute",		lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Toggle mute"),
	Key([], "XF86AudioLowerVolume",	lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc="Decrease volume"),
	Key([], "XF86AudioRaiseVolume",	lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"), desc="Increase volume"),

	# Media
	Key([], "XF86AudioPlay",	lazy.spawn("playerctl play-pause"), desc="Play/pause media"),
	Key([], "XF86AudioPrev",	lazy.spawn("playerctl previous"), desc="Previous media"),
	Key([], "XF86AudioNext",	lazy.spawn("playerctl next"), desc="Next media"),\
]
