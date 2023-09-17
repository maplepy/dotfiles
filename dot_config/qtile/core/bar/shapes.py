from libqtile.bar import CALCULATED
from libqtile.lazy import lazy

from core.bar.base import base, powerline, rectangle
from extras import Clock, GroupBox, TextBox, modify, widget
from utils.palette import palette
from utils.config import cfg

bar = {
    "background": palette.base,
    "border_color": palette.base,
    "border_width": 4,
    # "margin": [10, 10, 0, 10],
    # "opacity": 0.1,
    "size": 20,
}

def symbol(size=17) -> dict:
    return {
    # font = "Symbols Nerd Font Mono Regular",
    "fontsize": size,
    "offset": -8
    }

def sep(fg, offset=0, padding=10):
    return TextBox(
        **base(None, fg),
        # fontsize=11,
        offset=offset,
        # padding=padding,
        text="󰇙",
    )


logo = lambda bg, fg: TextBox(
    **base(bg, fg),
    **rectangle(),
    mouse_callbacks={"Button1": lazy.restart()},
    text="",
    # padding=8,
)

groups = lambda bg: GroupBox(
    borderwidth=1,
    colors=[
        palette.blue,
        palette.peach,
        palette.red,
        palette.rosewater,
        palette.text,
        palette.green,
    ],
    highlight_color=palette.base,
    highlight_method="line",
    # inactive=palette.surface2,
    # fontsize=18,
    **symbol(),
    padding=4,
    rainbow=True,
)

volume = lambda bg, fg: [
    modify(TextBox,
        **base(bg, fg),
        **rectangle("left"),
        text="󰕾",
        **symbol(),
        # offset=-8,
    ),
    widget.Volume(
        **powerline("arrow_left"),
        **base(bg, fg),
        # emoji=True,
        # emoji_list=["󰝟", "󰕿", "󰖀", "󰕾"],
        step=5,
        # get_volume_command="pactl get-sink-volume @DEFAULT_SINK@ | grep -Pow '\d{0,3}+(?=%)' | head -1",
        # volume_app="pactl",

        # mute_command="pactl set-sink-mute @DEFAULT_SINK@ toggle",
        # volume_down_command="pactl set-sink-volume @DEFAULT_SINK@ -5%",
        # volume_up_command="pactl set-sink-volume @DEFAULT_SINK@ +5%",
    ),
]

updates = lambda bg, fg: [
    TextBox(
        **base(bg, fg),
        text="",
    ),
    widget.CheckUpdates(
        **base(bg, fg),
        **rectangle("right"),
        colour_have_updates=fg,
        colour_no_updates=fg,
        custom_command=" " if cfg.is_xephyr else "checkupdates",
        display_format="{updates} updates  ",
        initial_text="No updates  ",
        no_update_string="No updates  ",
        padding=0,
        update_interval=3600,
    ),
]

window_name = lambda fg: widget.WindowName(
    **base(None, fg),
    format="{name}",
    max_chars=60,
    width=CALCULATED,
)

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

battery = lambda bg, fg: [
    widget.Battery(
        **base(bg, fg),
        charge_char="",
        discharge_char="",
        empty_char="",
        format="{char} {percent:2.0%} {hour:d}:{min:02d} ",
        full_char="",
        low_percentage=0.2,
        low_foreground=palette.red,
        padding=0,
        show_short_text=False,
        update_interval=5,
        **rectangle("right"),
    ),
]

clock = lambda bg, fg: [
    # TextBox(
    #     # **rectangle("left"),
    #     **rectangle(),
    #     **base(bg, fg),
    #     text="",
    #     # **symbol(),
    # ),
    Clock(
        **base(bg, fg),
        **rectangle("left"),
        # format="%A %d/%m - %H:%M",
        # long_format="%B %-d, %Y ",
        # padding=7,
    ),
]


widgets = lambda: [
    # widget.Spacer(length=10),
    logo(palette.blue, palette.base),
    # sep(palette.surface2, offset=-24),
    groups(None),
    sep(palette.surface2, offset=8, padding=2),
    *volume(palette.pink, palette.base),
    *updates(palette.red, palette.base),
    widget.Spacer(),
    window_name(palette.text),
    widget.Spacer(),
    *cpu(palette.green, palette.base),
    *ram(palette.yellow, palette.base),
    *disk(palette.teal, palette.base),
    *battery(palette.surface1, palette.base),
    sep(palette.surface2),
    *clock(palette.pink, palette.base),
    logo(palette.pink, palette.base),
    # widget.Spacer(length=1),
]
