import asyncio
import os
import subprocess

from libqtile import hook, qtile
from libqtile.utils import send_notification

@hook.subscribe.client_urgent_hint_changed
def client_urgency_change(client):
    # if its counter strike then focus it
    send_notification("qtile", f"{client.name} has changed its urgency state")
    if client.name == "Counter-Strike: Global Offensive":
        client.group.cmd_toscreen()
        # client.cmd_focus()
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
    if "steam_app_" in client.window.get_wm_class()[0].lower():
        # Matched the window class, send it to group 8
        client.togroup("8")

