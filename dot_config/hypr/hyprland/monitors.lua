-- Monitor configuration
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
	output = "desc:HAT Kamvas 13",
	mode = "highres@highrr",
	position = "auto",
	scale = 1,
	transform = 2,
})

hl.monitor({
	output = "desc:Dell Inc. AW3425DWM 6Q0D444",
	mode = "3440x1440@180",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	vrr = 2,
})

hl.monitor({
	output = "desc:Ancor Communications Inc VG248 G3LMQS013154",
	disabled = true,
})

-- Laptop
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.monitor({
	output = "desc: Samsung Display Corp",
	mode = "preferred",
	position = "auto",
	scale = 1.6,
	bitdepth = 10,
	cm = "hdr",
	sdrbrightness = 1.2,
	sdrsaturation = 0.98,
	vrr = 1,
})
-- vrr | 0 = off, 1 = on, 2 = fullscreen only, 3 = fullscreen with game or video content type

-- Tablet output mapping
hl.device({
	name = "opentabletdriver-virtual-artist-tablet",
	output = "HDMI-A-1",
})
hl.device({
	name = "opentabletdriver-virtual-tablet",
	output = "HDMI-A-1",
})
