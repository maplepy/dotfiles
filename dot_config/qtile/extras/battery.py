import asyncio
from typing import List, Tuple, Union
import logging

from libqtile import bar, widget
from dbus_next.aio import MessageBus
from dbus_next.constants import BusType

# Define constants for DBus service and interface
UPOWER_SERVICE = "org.freedesktop.UPower"
UPOWER_PATH = "/org/freedesktop/UPower"
UPOWER_INTERFACE = "org.freedesktop.UPower.Device"
PROPS_IFACE = "org.freedesktop.DBus.Properties"

# Set up logging
logger = logging.getLogger(__name__)


class UPowerWidget(widget.base._Widget):
    """
    A graphical widget to display laptop battery level using UPower.

    The widget uses dbus to read the battery information from the UPower
    interface.

    The widget will display one icon for each battery found or users can
    specify the name of the battery if they only wish to display one.

    Clicking on the widget will display the battery level and the time to
    empty/full.

    All colours can be customised as well as low/critical percentage levels.
    """

    orientations = widget.base.ORIENTATION_HORIZONTAL
    defaults = [
        ("font", "sans", "Default font"),
        ("fontsize", None, "Font size"),
        ("foreground", "ffffff", "Font colour for information text"),
        ("battery_height", 10, "Height of battery icon"),
        ("battery_width", 20, "Size of battery icon"),
        ("battery_name", None, "Battery name. None = all batteries"),
        ("border_charge_colour", "8888ff", "Border colour when charging."),
        ("border_colour", "dbdbe0", "Border colour when discharging."),
        ("border_critical_colour", "cc0000", "Border colour when battery low."),
        ("fill_normal", "dbdbe0", "Fill when normal"),
        ("fill_low", "aa00aa", "Fill colour when battery low"),
        ("fill_critical", "cc0000", "Fill when critically low"),
        ("fill_charge", None, "Override fill colour when charging"),
        ("margin", 2, "Margin on sides of widget"),
        ("spacing", 5, "Space between batteries"),
        ("percentage_low", 0.20, "Low level threshold."),
        ("percentage_critical", 0.10, "Critical level threshold."),
        (
            "text_charging",
            "({percentage:.0f}%) {ttf} until fully charged",
            "Text to display when charging.",
        ),
        (
            "text_discharging",
            "({percentage:.0f}%) {tte} until empty",
            "Text to display when on battery.",
        ),
        ("text_displaytime", 5, "Time for text to remain before hiding"),
    ]

    def __init__(self, **config):
        super().__init__(bar.CALCULATED, **config)
        self.add_defaults(UPowerWidget.defaults)
        self.batteries = []
        self.charging = False
        self.show_text = False
        self.hide_timer = None
        self.configured = False
        self.bus = None

        # Set up click event
        self.add_callbacks({"Button1": self.toggle_text})

    async def _config_async(self):
        await self._setup_dbus()

    async def _setup_dbus(self):
        try:
            self.bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
            introspection = await self.bus.introspect(UPOWER_SERVICE, UPOWER_PATH)
            obj = self.bus.get_proxy_object(UPOWER_SERVICE, UPOWER_PATH, introspection)
            self.upower = obj.get_interface(UPOWER_INTERFACE)
            self.props = obj.get_interface(PROPS_IFACE)
            self.props.on_properties_changed(self._upower_change)
            self.charging = not await self.upower.get_on_battery()
            self.batteries = await self._find_batteries()
            self.configured = await self._update_battery_info()
        except Exception as e:
            logger.error(f"Error setting up DBus: {e}")

    async def _find_batteries(self):
        try:
            batteries = await self.upower.call_enumerate_devices()
            batteries = [b for b in batteries if "battery" in b]

            if not batteries:
                logger.warning("No batteries found.")
                return []

            battery_devices = []
            for battery in batteries:
                introspection = await self.bus.introspect(UPOWER_SERVICE, battery)
                obj = self.bus.get_proxy_object(UPOWER_SERVICE, battery, introspection)
                device = obj.get_interface(UPOWER_INTERFACE)
                props = obj.get_interface(PROPS_IFACE)
                name = await device.get_native_path()
                props.on_properties_changed(self._battery_change)
                battery_devices.append({"device": device, "props": props, "name": name})

            # If battery_name is specified, filter batteries
            if self.battery_name:
                battery_devices = [b for b in battery_devices if b["name"] == self.battery_name]

                if not battery_devices:
                    logger.warning(f"No battery found matching '{self.battery_name}'.")

            return battery_devices
        except Exception as e:
            logger.error(f"Error finding batteries: {e}")
            return []

    async def _update_battery_info(self):
        try:
            for battery in self.batteries:
                dev = battery["device"]
                percentage = await dev.get_percentage()
                battery["fraction"] = percentage / 100.0
                battery["percentage"] = percentage
                if self.charging:
                    ttf = await dev.get_time_to_full()
                    battery["ttf"] = self._secs_to_hm(ttf)
                    battery["tte"] = ""
                else:
                    tte = await dev.get_time_to_empty()
                    battery["tte"] = self._secs_to_hm(tte)
                    battery["ttf"] = ""
                battery["status"] = next(
                    x[1] for x in self.status if battery["fraction"] <= x[0]
                )

            self.bar.draw()
            return True
        except Exception as e:
            logger.error(f"Error updating battery info: {e}")
            return False

    async def _upower_change(self, *args, **kwargs):
        try:
            self.charging = not await self.upower.get_on_battery()
            await self._update_battery_info()
        except Exception as e:
            logger.error(f"Error handling UPower change: {e}")

    def _battery_change(self, *args, **kwargs):
        asyncio.create_task(self._update_battery_info())

    def draw(self):
        # Your drawing logic here
        pass

    def toggle_text(self):
        # Your toggle text logic here
        pass

    def _secs_to_hm(self, secs: int) -> str:
        # Your seconds to hour-minute conversion logic here
        pass

    def finalize(self):
        if self.props:
            self.props.off_properties_changed(self._upower_change)
        if self.bus:
            self.bus.disconnect()
        super().finalize()
