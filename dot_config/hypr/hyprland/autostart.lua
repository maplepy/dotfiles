-- Autostart programs
-- See https://wiki.hypr.land/Configuring/Autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("qs -c " .. Programs.qsConfig)
	hl.exec_cmd("vicinae server")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("xrdb ~/.Xresources") -- Load X resources for proper DPI scaling
end)
