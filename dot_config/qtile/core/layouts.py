# QTile config - layouts
# by maplepy

from libqtile import layout

from core.groups import wm_class, title
from core.palette import palette

config = {
	"border_focus": palette.lavender,
	"border_normal": palette.base,
	"single_margin": 0,
	"single_border_width": 0,
	"margin": 4,
	"border_width": 1,
}

monad = {
	**config,
	"ratio": 0.55,
	"change_ratio": 0.01,
	# "change_size": 2,
	# "min_ratio": 0.30,
	# "max_ratio": 0.70,
}


layouts = [
	layout.MonadTall(**monad),
	layout.MonadWide(**monad),
	# layout.Max(**config),

	# layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
	# layout.Stack(num_stacks=2),
	# layout.Bsp(),
	# layout.Matrix(),
	# layout.RatioTile(),
	# layout.Tile(),
	# layout.TreeTab(),
	# layout.VerticalTile(),
	# layout.Zoomy(),
]

floating_layout = layout.Floating(
	border_focus=palette.red,
	border_normal=palette.base,
	border_width=0,
	fullscreen_border_width=0,
	float_rules=[
		*layout.Floating.default_float_rules,
		# Run the utility of `xprop` to see the wm class and name of an X client.
		*wm_class(
			"lxappearance",
			"Pavucontrol",
			"Yad"
		),
		# *title(
		# 	"minecraft-launcher",
		# ),
	],
)
