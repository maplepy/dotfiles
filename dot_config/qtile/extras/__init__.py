# Import necessary modules from qtile_extras
from qtile_extras import widget  # type: ignore
from qtile_extras.widget import modify  # type: ignore
from qtile_extras.widget.decorations import (  # type: ignore
    BorderDecoration,
    PowerLineDecoration,
    RectDecoration,
)

# Import custom widgets and functions from extras
from extras.clock import Clock
from extras.groupbox import GroupBox
from extras.misc import float_to_front
from extras.textbox import TextBox
from extras.battery import UPowerWidget
from extras.network import WiFiIcon
from extras.mic import MicWidget
