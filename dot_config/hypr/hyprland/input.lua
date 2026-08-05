-- Input devices
-- See https://wiki.hypr.land/Configuring/Variables/#input

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "compose:ralt",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		accel_profile = "flat",
		numlock_by_default = true,
		touchpad = {
			natural_scroll = true,
		},
		tablet = {
			output = "HDMI-A-1",
			left_handed = true,
		},
	},
})

hl.device({
	name = "syna2ba6:00-06cb:cfd3-touchpad",
	sensitivity = 0.2,
})
