-- ponytail: glow can only be toggled globally (no per-window/per-workspace field
-- exists in the Lua API as of 0.56.1 -- confirmed by testing hl.window_rule with
-- glow/no_glow/glow_color/glow_enabled, all rejected as unknown fields). So we
-- approximate "no glow when solo" by watching the active workspace's window count
-- and flipping the global decoration.glow.enabled toggle. Upgrade path: if Hyprland
-- ever adds a per-window glow rule field, replace this whole file with a window_rule.

local function updateGlow()
	local ws = hl.get_active_workspace()
	if not ws then
		return
	end
	local windows = hl.get_workspace_windows(ws.id)
	hl.config({ decoration = { glow = { enabled = #windows > 1 } } })
end

hl.on("window.open", updateGlow)
hl.on("window.close", updateGlow)
hl.on("window.move_to_workspace", updateGlow)
hl.on("workspace.active", updateGlow)
hl.on("hyprland.start", updateGlow)
