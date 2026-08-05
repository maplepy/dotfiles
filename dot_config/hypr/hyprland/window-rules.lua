-- Layer rules, window rules, and workspace assignment rules
-- See https://wiki.hypr.land/Configuring/Layer-Rules/ and Window-Rules/

-- ==================== LAYER RULES ====================

hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, animation = "slide right", ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "albert" }, ignore_alpha = 0 })
hl.layer_rule({ name = "vicinae-blur", match = { namespace = "vicinae" }, blur = true, ignore_alpha = 0 })

-- ==================== SMART GAPS ====================

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ name = "smartgaps-tv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
hl.window_rule({ name = "smartgaps-f1", match = { float = false, workspace = "f[1]" }, border_size = 0, rounding = 0 })

-- ==================== WINDOWS ====================

-- Picture in Picture
hl.window_rule({
	name = "pip",
	match = { title = "Picture-in-Picture" },
	pin = true,
	float = true,
	rounding = 0,
	no_initial_focus = true,
	keep_aspect_ratio = true,
	size = "(monitor_w*0.25) ((monitor_w*0.25)*9/16)",
	move = "(monitor_w-window_w-10) (monitor_h-window_h-10)",
})

-- Floating apps
hl.window_rule({
	name = "file-dialogs-float",
	match = { title = "^(Open File|Open|Save|Save As|Export|Import|Choose File)$", class = "^(.*)$" },
	float = true,
	center = true,
})
hl.window_rule({
	name = "xdg-desktop-portal-gtk-float",
	match = { class = "^(x|X)dg-desktop-portal-gtk$" },
	float = true,
	center = true,
})
hl.window_rule({ match = { class = "^.*pavucontrol.*$" }, float = true })
hl.window_rule({ match = { class = "^.*Overskride.*$" }, float = true })
hl.window_rule({ match = { class = "^yad$" }, float = true })

-- VoiceFlow TTS popup — always visible, bottom-center, no blur/border
hl.window_rule({
	name = "voiceflow-tts",
	match = { class = "VoiceFlow" },
	float = true,
	pin = true,
	no_initial_focus = true,
	no_focus = true,
	move = "(monitor_w-window_w)/2 (monitor_h-window_h-5)",
	opacity = 0.75,
	no_blur = true,
	border_size = 0,
})

-- Tiled apps
hl.window_rule({ match = { class = "^pdfxedit.exe$" }, tile = true })

-- Albert launcher — fix focus issues
hl.window_rule({
	name = "albert-launcher",
	match = { class = "^albert$" },
	float = true,
	center = true,
	pin = true,
	stay_focused = true,
	dim_around = true,
})

-- Ignore maximize requests from apps
hl.window_rule({ match = { class = "^.*$" }, suppress_event = "maximize" })

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

-- Video downloader special workspace
hl.window_rule({ match = { title = "(Video Downloader)" }, workspace = "special:ytdl" })

-- Pinned window border color (was: hyprland/colors.conf windowrule border_color, match:pin 1)
hl.window_rule({
	match = { pin = true },
	border_color = Colors.pin_border_active .. " " .. Colors.pin_border_inactive,
})

-- ==================== WORKSPACES ====================

-- Workspace 1: Code
for _, class in ipairs({ "code", "jetbrains-webstorm", "^.*Zed.*$", "^(Windsurf|.*Cursor.*|Kiro)$" }) do
	hl.window_rule({ match = { class = class }, workspace = "1 silent" })
end

-- Workspace 2: Web browser
hl.window_rule({ match = { class = "^zen$" }, workspace = "2 silent" })

-- Workspace 3: Media
for _, class in ipairs({ "^FreeTube$", "^.*Celluloid.*$", "^com.stremio.stremio$" }) do
	hl.window_rule({ match = { class = class }, workspace = "3 silent" })
end

-- Workspace 4: Docs/editing
for _, class in ipairs({ "^anytype$", "^pdfxedit.exe$" }) do
	hl.window_rule({ match = { class = class }, workspace = "4 silent" })
end

-- Workspace 5: Communication
for _, class in ipairs({ "^(.*Discord.*|vesktop|equibop)$", "^.*Element.*$", "^Beeper$" }) do
	hl.window_rule({ match = { class = class }, workspace = "5 silent" })
end
hl.window_rule({
	name = "signal-comm",
	match = { class = "^signal$" },
	workspace = "5 silent",
	no_screen_share = true,
})

-- Workspace 6: AI
hl.window_rule({ match = { class = "^Invoke.*$" }, workspace = "6 silent" })

-- Workspace 8: Games
hl.window_rule({ match = { workspace = "8" }, border_size = 0 })
hl.window_rule({ match = { workspace = "8" }, rounding = 0 })
for _, class in ipairs({ "^steam_app_\\d+$", "^Minecraft.*$|gmod|hl2_linux|factorio|dota2", ".*jackbox.*" }) do
	hl.window_rule({ match = { class = class }, workspace = "8" })
end

-- Workspace 9: Gaming/Steam
for _, class in ipairs({
	"^steam$",
	"^gale$",
	"^.*Lutris.*$",
	"^.*Heroic.*$",
	"^.*PrismLauncher$",
	"codes.merritt.Nyrna",
}) do
	hl.window_rule({ match = { class = class }, workspace = "9 silent" })
end

-- Workspace 10: Music
for _, class in ipairs({ "SpotiFLAC", "feishin" }) do
	hl.window_rule({ match = { class = class }, workspace = "10 silent" })
end
