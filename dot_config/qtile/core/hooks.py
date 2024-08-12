import asyncio
import os
import subprocess
import time

from libqtile import qtile, hook
from libqtile.utils import send_notification
import qtile_extras.hook

# Startup
@hook.subscribe.startup_once
def run_at_startup():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# Focus on game
@hook.subscribe.client_urgent_hint_changed
def client_urgency_change(client):
    # if its counter strike then focus it
    send_notification("qtile", f"{client.name} has changed its urgency state")
    if client.name == "Counter-Strike 2":
        client.group.cmd_toscreen()
        time.sleep(0.4)
        subprocess.call(["xdotool", "mousemove", "959", "454"])
        # subprocess.call(["xdotool", "mousemove", "959", "454", "click", "1"])
        time.sleep(0.4)
        subprocess.call(["xdotool", "click", "1"])
    # if client.urgent:

# Move Steam games to Window 8
@hook.subscribe.client_new
def steam_app_to_group(client):
    # await asyncio.sleep(0.5)
    # except steam_app_1868140
    if client.window.get_wm_class()[0].lower() == "steam_app_1868140":
        send_notification("qtile", f"Amuse toi bien sur {client.name}")
        return
    elif "steam_app_" in client.window.get_wm_class()[0].lower():
        send_notification("qtile", f"{client.name} has been moved to group 8")
        client.togroup("8")


# Github notifications
@qtile_extras.hook.subscribe.ghn_new_notification
def ghn_notification():
    qtile.spawn("ffplay ding.wav")
    send_notification("GitHub", "You have a new notification")


# Battery
@qtile_extras.hook.subscribe.up_battery_full
def battery_full(battery_name):
    send_notification(battery_name, "Battery is fully charged.")

@qtile_extras.hook.subscribe.up_battery_low
def battery_low(battery_name):
    send_notification(battery_name, "Battery is running low.")

@qtile_extras.hook.subscribe.up_battery_critical
def battery_critical(battery_name):
    send_notification(battery_name, "Battery is critically low. Plug in power supply.")


# Power
@qtile_extras.hook.subscribe.up_power_connected
def plugged_plugged():
    qtile.spawn("ffplay power_on.wav")
    send_notification("Power", "Power supply is plugged in.")

@qtile_extras.hook.subscribe.up_power_disconnected
def power_unplugged():
    qtile.spawn("ffplay power_off.wav")
    send_notification("Power", "Power supply is unplugged.")


# Volume
@qtile_extras.hook.subscribe.volume_change
def vol_change(volume, muted):
    send_notification("Volume change", f"Volume is now {volume}%")

@qtile_extras.hook.subscribe.volume_mute_change
def mute_change(volume, muted):
    if muted:
      send_notification("Volume change", "Volume is now muted.")


# Qtile
@hook.subscribe.startup_complete
def run_every_startup():
    send_notification("qtile", "Startup complete")


# Sleep
@hook.subscribe.suspend
def prepare_for_sleep():
    # Lock screen
    # subprocess.run(["i3lock-fancy"])
    subprocess.run(["betterlockscreen", "-l", "dimblur"])

    # Mute sound
    subprocess.run(["amixer", "-q", "sset", "Master", "mute"])

    # Pause media (example using playerctl)
    subprocess.run(["playerctl", "pause"])

    # Create a file to check if the system was suspended
    with open("/tmp/suspended", "w") as f:
        f.write("Suspended")

@hook.subscribe.resume
def actions_on_resume():
    # Unmute sound
    subprocess.run(["amixer", "-q", "sset", "Master", "unmute"])



# @hook.subscribe.focus_change
# def focus_changed():
#     send_notification("qtile", "Focus changed.")


# @hook.subscribe.focus_change # breaks two floating on top of each other
# def _():
#     for window in qtile.current_group.windows:
#         if window.floating:
#             window.cmd_bring_to_front()

# @hook.subscribe.startup
# def run_every_startup():

# @hook.subscribe.net_wm_icon_change
# def icon_change(client):
#     send_notification("qtile", f"{client.name} has changed its icon")

# Window Swallowing
# import psutil
#
# @hook.subscribe.client_new
# def _swallow(window):
#     pid = window.window.get_net_wm_pid()
#     ppid = psutil.Process(pid).ppid()
#     cpids = {c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()}
#     for i in range(5):
#         if not ppid:
#             return
#         if ppid in cpids:
#             parent = window.qtile.windows_map.get(cpids[ppid])
#             parent.minimized = True
#             window.parent = parent
#             return
#         ppid = psutil.Process(ppid).ppid()
#
# @hook.subscribe.client_killed
# def _unswallow(window):
#     if hasattr(window, 'parent'):
#         window.parent.minimized = False
