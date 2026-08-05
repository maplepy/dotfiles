-- Keybindings
-- See https://wiki.hypr.land/Configuring/Binds/
--
-- ponytail: original hyprlang wrapped these in `submap = global` (with
-- `exec = hyprctl dispatch submap global` activating it at startup) purely
-- as an organizational quirk carried over from a dotfiles template — net
-- runtime effect is identical to plain default-submap binds. Skipping the
-- submap wrapper entirely; these are flat top-level binds. Revisit only if
-- testing shows quickshell global-dispatcher binds misbehave.

local mainMod = Programs.mainMod

-- Apps
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(Programs.webBrowser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(Programs.terminalCmd .. " " .. Programs.fileManager))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(Programs.terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(Programs.menu))

hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(Programs.colorPicker))

-- whisrs — voice-to-text dictation
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("/usr/bin/whisrs toggle"))

-- Video downloader
hl.bind(
	mainMod .. " + Y",
	hl.dsp.exec_cmd(
		"[workspace special:ytdl silent] " .. Programs.terminalCmd .. " ~/.config/scripts/utils/video_download_ytlp.sh --headless"
	)
)
hl.bind(
	mainMod .. " + SHIFT + Y",
	hl.dsp.exec_cmd(
		"[workspace special:ytdl silent] " .. Programs.terminalCmd .. " ~/.config/scripts/utils/video_download_ytlp.sh --headless --audio"
	)
)
hl.bind(mainMod .. " + CTRL + Y", hl.dsp.workspace.toggle_special("ytdl"))

-- Quick Shell
hl.bind("Super_L", hl.dsp.global("quickshell:workspaceNumber"), { non_consuming = true })
hl.bind("Super_R", hl.dsp.global("quickshell:searchToggleRelease"), { description = "Toggle search" })
hl.bind(mainMod .. " + G", hl.dsp.global("quickshell:overlayToggle"))
hl.bind(mainMod .. " + Slash", hl.dsp.global("quickshell:cheatsheetToggle"), { description = "Toggle cheatsheet" })
hl.bind("CTRL + ALT + Delete", hl.dsp.global("quickshell:sessionToggle"), { description = "Toggle session menu" })
hl.bind(mainMod .. " + J", hl.dsp.global("quickshell:barToggle"), { description = "Toggle bar" })

-- Window management
-- verify: force-close mapping (kill vs destroy) and fullscreen_state/workspace.move
-- arg shapes below are inferred from stub field names, not from a literal example;
-- confirm with `hyprctl reload` + manual test, adjust if behavior is off.
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + CTRL + SHIFT + M", hl.dsp.exit())

hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.pin())

hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen())
-- ponytail: original hyprlang `fullscreenstate, toggle` isn't valid dispatcher
-- syntax (fullscreenstate takes required internal/client ints, no "toggle"
-- keyword) — was likely already inert in the old config. Aliasing to the
-- same full toggle as F11 to guarantee a working bind; revisit if you want
-- distinct internal/client fullscreen behavior.
hl.bind(mainMod .. " + SHIFT + F11", hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.workspace.move({ monitor = "r" }))

hl.bind(mainMod .. " + CTRL + LEFT", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + UP", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(mainMod .. " + CTRL + DOWN", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

-- Mouse binds (submap_universal = fires even inside other submaps, e.g. resize submap)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, submap_universal = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, submap_universal = true })

-- Screenshots & recording
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('qs -c ii ipc call TEST_ALIVE || grim -g "$(slurp)" - | wl-copy'))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + Print", hl.dsp.global("quickshell:regionOcr"))
hl.bind("Print", hl.dsp.exec_cmd("qs -c ii ipc call region screenshot"))
hl.bind("CTRL + ALT + Print", hl.dsp.exec_cmd("~/.config/scripts/utils/screenshot.sh"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("~/.config/scripts/utils/screenshot.sh window"))
hl.bind("CTRL + Print", hl.dsp.global("quickshell:regionSearch"))

-- Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. Programs.volumeStep .. "-"),
	{ repeating = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. Programs.volumeStep .. "+ -l 1.2"),
	{ repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })

hl.bind(
	mainMod .. " + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SOURCE@ " .. Programs.volumeStep .. "- || ~/.config/scripts/osd/volume.sh mic-down")
)
hl.bind(
	mainMod .. " + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SOURCE@ " .. Programs.volumeStep .. "+ || ~/.config/scripts/osd/volume.sh mic-up")
)

hl.bind(
	mainMod .. " + XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),
	{ locked = true, description = "Toggle microphone mute" }
)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

hl.bind("CTRL + ALT + XF86AudioMute", hl.dsp.exec_cmd("pavucontrol"))

hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(
		"qs -c " .. Programs.qsConfig .. " ipc call brightness increment " .. Programs.brightnessStep .. " || ~/.config/scripts/osd/brightness.sh up"
	),
	{ repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(
		"qs -c " .. Programs.qsConfig .. " ipc call brightness decrement " .. Programs.brightnessStep .. " || ~/.config/scripts/osd/brightness.sh down"
	),
	{ repeating = true }
)

-- Session
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Workspace
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
