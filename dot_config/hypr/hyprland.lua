-- Hyprland 0.55+ Lua config entry point
-- Old hyprlang .conf files kept alongside as fallback; this file takes precedence when present.

Programs = {
	mainMod = "SUPER",
	volumeStep = "2%",
	brightnessStep = "2",
	terminal = "kitty",
	terminalCmd = "kitty -e",
	fileManager = "yazi",
	menu = "vicinae toggle",
	webBrowser = "zen-browser",
	colorPicker = "hyprpicker -a",
	editor = "nvim",
	screenshot = "grim",
	qsConfig = "ii",
}

Colors = require("hyprland/colors")

require("hyprland/monitors")
require("hyprland/env")
require("hyprland/autostart")
require("hyprland/appearance")
require("hyprland/input")
require("hyprland/keybinds")
require("hyprland/window-rules")
require("hyprland/dynamic-glow")

hl.config({
	xwayland = { force_zero_scaling = true },
	ecosystem = { no_donation_nag = true },
})
