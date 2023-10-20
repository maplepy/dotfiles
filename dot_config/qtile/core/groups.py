# QTile config - groups
# by maplepy

import asyncio
from libqtile.config import Group, Key, Match, Click, Drag
from libqtile.lazy import lazy

from core.keys import keys, mod


# class Matches:
# 	def __init__(self, property: str, values: tuple):
# 		self.property = property
# 		self.values = values

# 	def generate(self) -> list[Match]:
# 		return [Match(**{self.property: i}) for i in self.values]

# Define a helper function to generate Match objects
def generate_matches(property: str, values: tuple) -> list[Match]:
	return [Match(**{property: i}) for i in values]

def wm_class(*values: str):
	# return Matches("wm_class", values).generate()
	return generate_matches("wm_class", values)

def title(*values: str):
	# return Matches("title", values).generate()
	return generate_matches("title", values)


groups: list[Group] = []

for key, label, layout, matches in [
	("1", "", None, wm_class("VSCodium", "code")),
	("2", "󰈹", None, wm_class("firefox", "LibreWolf")),
	("3", "", None, wm_class("FreeTube", "mpv")),
	("4", "󰈙", None, wm_class("obsidian")),
	("5", "󰇮", None, wm_class("Signal", "discord", "VencordDesktop", "telegram-desktop")),
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


from libqtile import hook

# from core.screens import screens

# bars = [screen.top for screen in screens]
# margins = [sum(bar.margin) if bar else -1 for bar in bars]  # type: ignore


# @hook.subscribe.startup
# def startup():
# 	for bar, margin in zip(bars, margins):
# 		if not margin:
# 			bar.window.window.set_property(
# 				name="WM_NAME",
# 				value="QTILE_BAR",
# 				type="STRING",
# 				format=8,
# 			)

@hook.subscribe.client_new
async def client_new(client):
	await asyncio.sleep(0.5)
	if client.name == "Spotify":
		client.togroup("0")
