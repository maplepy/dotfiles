# QTile config - global settings
# by maplepy

from libqtile import layout
from libqtile.config import Click, Drag, Group, Key, Match
from libqtile.lazy import lazy

# Import groups
from core.groups import groups

# Hotkeys
from core.keys import keys, mod

# Layouts
from core.layouts import layouts, floating_layout

# Bar
from core.bar import screens, widget_defaults

# Hooks
from core import hooks

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

# floating_layout = layout.Floating(
# 	float_rules=[
# 		# Run the utility of `xprop` to see the wm class and name of an X client.
# 		*layout.Floating.default_float_rules,
# 		Match(wm_class="confirmreset"),  # gitk
# 		Match(wm_class="makebranch"),  # gitk
# 		Match(wm_class="maketag"),  # gitk
# 		Match(wm_class="ssh-askpass"),  # ssh-askpass
# 		Match(title="branchdialog"),  # gitk
# 		Match(title="pinentry"),  # GPG key password entry
# 	]
# )

from libqtile import bar, widget
from libqtile.config import Screen

# widget_defaults = dict(
# 	font="JetBrainsMonoNL Nerd Font Propo",
# 	fontsize=14,
# 	padding=2,
# )

# screens = [
# 	Screen(
# 		wallpaper="~/.local/wallpapers/evening-sky-flipped.png",
# 		wallpaper_mode="fill",
# 		top=bar.Bar([
# 				widget.CurrentLayout(),
# 				widget.GroupBox(),
# 				widget.Prompt(),
# 				widget.WindowName(),
# 				widget.Battery(
# 					discharge_char="v",
# 					format="{char} {percent:2.0%} {hour:d}:{min:02d}",
# 					notify_below=20,
# 					low_percentage=0.2,
# 					low_foreground="#ff0000",
# 					),# display the battery state
# 				widget.Chord(
# 					chords_colors={
# 						"launch": ("#ff0000", "#ffffff"),
# 					},
# 					name_transform=lambda name: name.upper(),
# 				),
# 				# widget.TextBox("default config", name="default"),
# 				# widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
# 				# NB Systray is incompatible with Wayland, consider using StatusNotifier instead
# 				# widget.StatusNotifier(),
# 				widget.Systray(),
# 				widget.Clock(format="%Y-%m-%d %a %H:%M"),
# 				# widget.QuickExit(),
# 			],
# 			20,
# 			# border_width=[2, 0, 2, 0],  # Draw top and bottom borders
# 			# border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
# 		),
# 	),
# ]


auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
