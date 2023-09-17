from libqtile.config import Group, Key
from libqtile.lazy import lazy

from core.keys import keys, mod
from utils.match import wm_class
from utils.palette import palette  # Import your color palette here

groups: list[Group] = []

for key, label, color, layout, persist, matches in [
	("1", "", palette.blue, None, False, wm_class("VSCodium", "code")),
	("2", "󰈹", palette.peach, None, False, wm_class("firefox", "LibreWolf")),
	("3", "", palette.mauve, None, False, wm_class("FreeTube", "mpv")),
	("4", "󰈙", palette.rosewater, None, False, wm_class("obsidian")),
	("5", "󰇮", palette.sky, None, False, wm_class("Signal", "discord", "telegram-desktop")),
	("0", "", palette.green, None, False, wm_class("spotify")),
]:
	groups.append(Group(key, matches, label=label, layout=layout))

	keys.extend([
		# Move focus to group
		Key([mod], key, lazy.group[key].toscreen()),

		# Move window to group
		Key([mod, "shift"], key, lazy.window.togroup(key)),
	])
