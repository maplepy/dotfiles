# QTile config - bar
# by maplepy

from libqtile.bar import CALCULATED
from libqtile.lazy import lazy
from libqtile.config import Screen
from libqtile import bar, widget

from core.palette import palette
from extras import (
    Clock,
    GroupBox,
    TextBox,
    modify,
    widget,
    PowerLineDecoration,
    RectDecoration,
)

# Bar configuration
bar_config = {
    "background": palette.base,
    "border_color": palette.base,
    "border_width": 2,
    "size": 20,
}

widget_defaults = dict(
    font="JetBrainsMonoNL Nerd Font Propo",
    fontsize=14,
    # padding=2,
)


def base(bg: str | None, fg: str) -> dict:
    return {
        "foreground": fg,
        "background": bg,  # Color or image path.
    }


def powerline(path: str | list[tuple], size=8):
    return {
        "decorations": [
            PowerLineDecoration(
                path=path,  # Path to a powerline image or a list of tuples for gradient.
                size=size,  # Size of the powerline decoration.
            )
        ]
    }


def rectangle(side="", radius=4):
    return {
        "decorations": [
            RectDecoration(
                filled=True,
                radius={
                    "left": [radius, 0, 0, radius],
                    "right": [0, radius, radius, 0],
                }.get(side, radius),
                use_widget_background=True,
            )
        ]
    }


def symbol(size=18, offset=0) -> dict:
    return {
        "fontsize": size,
        "offset": offset,
    }


def sep(fg, offset=0, padding=10):
    return TextBox(
        **base(None, fg),
        offset=offset,
        text="󰇙",
    )


layout = lambda bg, fg: [
    modify(
        TextBox,
        **base(bg, fg),
        **rectangle("left"),
        text="",
        mouse_callbacks={"Button1": lazy.restart()},
    ),
    widget.CurrentLayout(
        **base(bg, fg),
        **rectangle("right"),
    ),
]

groups = lambda bg: GroupBox(
    **symbol(),
    disable_drag=True,
    colors=[
        palette.blue,
        palette.peach,
        palette.red,
        palette.rosewater,
        palette.text,
        palette.green,
    ],
    highlight_color=palette.crust,
    highlight_method="line",
    inactive=palette.surface0,
    fontshadow=palette.crust,
    borderwidth=2,
    # padding=4,
    rainbow=True,
    # rounded=True,
    # toggle=True,
    urgent_alert_method="border",
    urgent_border="FF0000",
    urgent_text="FF0000",
    # visible_groups=None,
)

window_name = lambda fg: widget.WindowName(
    **base(None, fg),
    max_chars=60,
)

updates = lambda bg, fg: widget.CheckUpdates(
    **base(bg, fg),
    **rectangle(),
    # initial_text="No updates",
    colour_have_updates=fg,
    display_format=" {updates}",
    # padding=6,
    # update_interval=3600,
    execute="kitty -e yay -Syu --noconfirm --sudoloop --cleanafter",
)

player = lambda bg, fg: widget.Mpris2(
    **base(bg, fg),
    format="{xesam:artist} - {xesam:title}",
    paused_text=" {track}",
    playing_text=" {track}",
    mouse_callbacks={
        "Button1": lazy.spawn("playerctl play-pause"),
        "Button2": lazy.spawn("playerctl previous"),
        "Button3": lazy.spawn("playerctl next"),
    },
    name="spotify",
    objname="org.mpris.MediaPlayer2.spotify",
    # scroll_step=5,
    width=280,
    # scroll_fixed_width=True,
)

wifi = lambda bg, fg: [
    widget.Wlan(
        **base(bg, fg),
        **rectangle(""),
        format="󰖩 {percent:.0%} {essid:.11}",
        # disconnected_message="󰖪 Disconnected",
        mouse_callbacks={
            "Button1": lazy.spawn("kitty -e iwctl"),
        },
    ),
]

volume = lambda bg, fg: [
    widget.Volume(
        **base(bg, fg),
        **symbol(),
        # **rectangle("left"),
        emoji=True,
        emoji_list=["󰝟", "󰕿", "󰖀", "󰕾"],
        step=5,
    ),
    widget.Volume(
        **base(bg, fg),
        # **rectangle("right"),
        step=5,
    ),
]

backlight = lambda bg, fg: widget.Backlight(
    **base(bg, fg),
    # **rectangle("right"),
    backlight_name="intel_backlight",
    format="{percent:.1%}",
    fmt="󰃠 {}",
)

battery = lambda bg, fg: widget.Battery(
    **base(bg, fg),
    # **rectangle("right"),
    charge_char="",
    discharge_char="",
    empty_char="",
    full_char="",
    format="{char} {percent:2.0%} {hour:d}:{min:02d}",
    low_percentage=0.2,
    # low_background=palette.red,2
    low_foreground=palette.red,
    notification_timeout=0,
    # show_short_text=False,
    # update_int2erval=5,
)

system_tray = lambda bg, fg: widget.Systray(
    **base(bg, fg),
    # **rectangle("right"),
    # icon_size=16,
    # padding=4,
)

clock = lambda bg, fg: modify(
    Clock,
    **base(bg, fg),
    **rectangle(),
    fmt="󱑃 {}",
    format="%a %d/%m %H:%M",
    long_format="%A %d %B %Y %H:%M:%S",
)


# battery = lambda bg, fg: [
#     widget.Battery(
#         **base(bg, fg),
#         charge_char="",
#         discharge_char="",
#         empty_char="",
#         format="{char} {percent:2.0%} {hour:d}:{min:02d} ",
#         full_char="",
#         low_percentage=0.2,
#         low_foreground=palette.red,
#         padding=0,
#         show_short_text=False,
#         update_interval=5,
#         **rectangle("right"),
#     ),
# ]


cpu = lambda bg, fg: [
    TextBox(
        **rectangle("left"),
        **base(bg, fg),
        **symbol(),
        text="󰍛",
        # fontsize=16,
        # offset=-8,
    ),
    widget.CPU(
        **base(bg, fg),
        format="{load_percent:.0f}%",
        **powerline("arrow_right"),
    ),
]

ram = lambda bg, fg: [
    TextBox(
        **base(bg, fg),
        **symbol(),
        # fontsize=14,
        # offset=-1,
        # padding=5,
        text="󰘚",
    ),
    widget.Memory(
        **base(bg, fg),
        format="{MemUsed: .0f}{mm} ",
        # padding=-3,
        **powerline("arrow_right"),
    ),
]

disk = lambda bg, fg: [
    TextBox(
        **base(bg, fg),
        **symbol(),
        text="",
        # fontsize=14,
        # x=-2,
    ),
    widget.DF(
        **powerline("arrow_right"),
        **base(bg, fg),
        format="{f} GB",
        partition="/",
        # padding=0,
        visible_on_warn=False,
        warn_color=fg,
        # **rectangle("right"),
    ),
]


widgets = [
    *layout(palette.blue, palette.base),
    # sep(palette.surface2),
    updates(palette.red, palette.base),
    groups(None),
    # widget.Spacer(),
    window_name(palette.text),
    # player(palette.base, palette.text),
    # *wifi(palette.base, palette.text),
    *volume(palette.base, palette.text),
    backlight(palette.base, palette.text),
    battery(palette.base, palette.text),
    clock(palette.blue, palette.base),
    system_tray(palette.base, palette.text),
    # widget.Spacer(length=10),
    # sep(palette.surface2, offset=-24),
    # sep(palette.surface2, offset=8, padding=2),
    # *volume(palette.pink, palette.base),
    # *updates(palette.red, palette.base),
    # widget.Spacer(),
    # window_name(palette.text),
    # widget.Spacer(),
    # *cpu(palette.green, palette.base),
    # *ram(palette.yellow, palette.base),
    # *disk(palette.teal, palette.base),
    # sep(palette.surface2),
    # logo(palette.pink, palette.base),
    # widget.Spacer(length=1),
]

# Screen configuration
screens = [
    Screen(
        wallpaper="~/.local/wallpapers/evening-sky-flipped.png",
        wallpaper_mode="fill",
        top=bar.Bar(widgets, **bar_config),
    ),
]

# Additional content...
