# QTile config - groups
# by maplepy

import asyncio
from libqtile.config import Group, Key, Match, Click, Drag, ScratchPad, DropDown
from libqtile.lazy import lazy

from core.keys import keys, mod

# Define a helper function to generate Match objects
def generate_matches(property: str, values: tuple) -> list[Match]:
	return [Match(**{property: i}) for i in values]

def wm_class(*values: str):
	return generate_matches("wm_class", values)

def title(*values: str):
	return generate_matches("title", values)


groups: list[Group] = []

for key, label, layout, matches in [
	("1", "", None, wm_class("VSCodium", "code", "jetbrains-clion")),
	("2", "󰈹", None, wm_class("firefox", "LibreWolf")),
	("3", "", None, wm_class("FreeTube", "mpv")),
	("4", "󰄄", None, wm_class("obsidian", "resolve", "darktable")),
	("5", "󰇮", None, wm_class("Signal", "discord", "VencordDesktop", "telegram-desktop")),
	("6", "󱚟", None, wm_class("SDConsole")),
	("8", "󰊗", None, None),
	("9", "󰓓", None, wm_class("steam", "Lutris", "debris.exe", "blacksmith.exe")),
	("0", "", None, wm_class("spotify")),
]:
	groups.append(Group(key, matches, label=label, layout=layout))

	keys.extend([
		Key([mod], key, lazy.group[key].toscreen(),
			desc="Switch to group {}".format(key)),

		# Move window to group
		Key([mod, "shift"], key, lazy.window.togroup(key, switch_group=True),
			desc="Switch to & move focused window to group {}".format(key))
	])

groups.append(ScratchPad("scratchpad", [
	DropDown("term", "kitty", opacity=0.9, height=0.6, width=0.6, x=0.2, y=0.2),
]))
