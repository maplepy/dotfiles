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

def wm_class_and_title(*values: str):
	return generate_matches("wm_class", values) + generate_matches("title", values)

def wm_class_and_not_title(wm_class: str, *values: str):
	return generate_matches("wm_class", [wm_class]) + generate_matches("title", values)



groups: list[Group] = []

for key, label, layout, matches in [
	("1", "", None, wm_class("VSCodium", "code", "jetbrains-clion")),
	("2", "󰈹", None, wm_class("firefox", "LibreWolf", "Thorium-browser", "mercury-default")),
	("3", "", None, wm_class("FreeTube", "mpv")),
	("4", "󰄄", None, wm_class("obsidian", "resolve", "darktable", "Rapid Photo Downloader", "krita")),
	("5", "󰇮", None, wm_class("Signal", "discord", "VencordDesktop", "telegram-desktop")),
	("6", "󱚟", None, wm_class("SDConsole")),
	("8", "󰊗", None, wm_class("Project Zomboid")),
    ("9", "󰓓", None, title("Steam")),
		# title("Steam")
        # wm_class_and_title("steam", "Steam") +
        # wm_class("Lutris", "debris.exe", "blacksmith.exe")
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


# # Define a rule to match windows with a class starting with "steam_app_"
# steam_app_rule = Match(wm_class="steam_app_*")

# # Apply the rule to send matched windows to group 8
# groups.append(Group("8", matches=[steam_app_rule]))
