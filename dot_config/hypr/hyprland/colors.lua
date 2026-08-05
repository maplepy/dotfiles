-- Color palette (merged from colors.conf + hyprland/colors.conf)
-- Consumed by appearance.lua via require("hyprland/colors")

local colors = {
	background = "rgba(191114ff)",
	error = "rgba(ffb4abff)",
	error_container = "rgba(93000aff)",
	inverse_on_surface = "rgba(372e31ff)",
	inverse_primary = "rgba(894a68ff)",
	inverse_surface = "rgba(eedfe3ff)",
	on_background = "rgba(eedfe3ff)",
	on_error = "rgba(690005ff)",
	on_error_container = "rgba(ffdad6ff)",
	on_primary = "rgba(521d39ff)",
	on_primary_container = "rgba(ffd8e7ff)",
	on_primary_fixed = "rgba(380723ff)",
	on_primary_fixed_variant = "rgba(6d3350ff)",
	on_secondary = "rgba(412a34ff)",
	on_secondary_container = "rgba(fed9e6ff)",
	on_secondary_fixed = "rgba(2a151fff)",
	on_secondary_fixed_variant = "rgba(59404aff)",
	on_surface = "rgba(eedfe3ff)",
	on_surface_variant = "rgba(d4c2c7ff)",
	on_tertiary = "rgba(492810ff)",
	on_tertiary_container = "rgba(ffdcc7ff)",
	on_tertiary_fixed = "rgba(301401ff)",
	on_tertiary_fixed_variant = "rgba(643e24ff)",
	outline = "rgba(9d8d92ff)",
	outline_variant = "rgba(504348ff)",
	primary = "rgba(feb0d2ff)",
	primary_container = "rgba(6d3350ff)",
	primary_fixed = "rgba(ffd8e7ff)",
	primary_fixed_dim = "rgba(feb0d2ff)",
	scrim = "rgba(000000ff)",
	secondary = "rgba(e0bdcaff)",
	secondary_container = "rgba(59404aff)",
	secondary_fixed = "rgba(fed9e6ff)",
	secondary_fixed_dim = "rgba(e0bdcaff)",
	shadow = "rgba(000000ff)",
	source_color = "rgba(d873a4ff)",
	surface = "rgba(191114ff)",
	surface_bright = "rgba(40373aff)",
	surface_container = "rgba(251d20ff)",
	surface_container_high = "rgba(30282bff)",
	surface_container_highest = "rgba(3b3236ff)",
	surface_container_low = "rgba(21191cff)",
	surface_container_lowest = "rgba(130c0fff)",
	surface_dim = "rgba(191114ff)",
	surface_tint = "rgba(feb0d2ff)",
	surface_variant = "rgba(504348ff)",
	tertiary = "rgba(f2bb98ff)",
	tertiary_container = "rgba(643e24ff)",
	tertiary_fixed = "rgba(ffdcc7ff)",
	tertiary_fixed_dim = "rgba(f2bb98ff)",

	-- overrides from hyprland/colors.conf (accent border colors)
	active_border = "rgba(a08d8777)",
	inactive_border = "rgba(53433f55)",
}

-- Border color for pinned windows (was: windowrule = border_color ... match:pin 1)
colors.pin_border_active = "rgba(ffb59cAA)"
colors.pin_border_inactive = "rgba(ffb59c77)"

-- ponytail: hyprbars plugin block (bar buttons/colors) intentionally NOT ported.
-- Plugin config Lua syntax needs separate lookup; old hyprland/colors.conf plugin{} block
-- still exists but is inert while hyprland.lua is active. Revisit when porting plugins.

return colors
