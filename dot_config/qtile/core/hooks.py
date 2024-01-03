import asyncio
import os
import subprocess
import time

from libqtile import hook, qtile
from libqtile.utils import send_notification

@hook.subscribe.client_urgent_hint_changed
def client_urgency_change(client):
    # if its counter strike then focus it
    send_notification("qtile", f"{client.name} has changed its urgency state")
    if client.name == "Counter-Strike 2":
        client.group.cmd_toscreen()
        time.sleep(0.2)
        subprocess.call(["xdotool", "mousemove", "959", "454"])
        # subprocess.call(["xdotool", "mousemove", "959", "454", "click", "1"])
        time.sleep(0.2)
        subprocess.call(["xdotool", "click", "1"])
    # if client.urgent:

@hook.subscribe.startup_once
def run_at_startup():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])

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

# @hook.subscribe.client_new
# async def client_new(client):
#     if client.name == "Spotify":
#         client.togroup("0")

# Move Steam games to Window 8
@hook.subscribe.client_new
def steam_app_to_group(client):
    # await asyncio.sleep(0.5)
    # except steam_app_1868140
    if client.window.get_wm_class()[0].lower() == "steam_app_1868140":
        send_notification("qtile", f"Amuse toi bien sur {client.name}")
        return
    elif "steam_app_" in client.window.get_wm_class()[0].lower():
        client.togroup("8")

    # if "steam_app_" in class and class != "steam_app_1868140":
    # # if "steam_app_" in client.window.get_wm_class()[0].lower():
        # Matched the window class, send it to group 8
        # client.togroup("8")

import psutil

@hook.subscribe.client_new
def _swallow(window):
    pid = window.window.get_net_wm_pid()
    ppid = psutil.Process(pid).ppid()
    cpids = {c.window.get_net_wm_pid(): wid for wid, c in window.qtile.windows_map.items()}
    for i in range(5):
        if not ppid:
            return
        if ppid in cpids:
            parent = window.qtile.windows_map.get(cpids[ppid])
            parent.minimized = True
            window.parent = parent
            return
        ppid = psutil.Process(ppid).ppid()

@hook.subscribe.client_killed
def _unswallow(window):
    if hasattr(window, 'parent'):
        window.parent.minimized = False
