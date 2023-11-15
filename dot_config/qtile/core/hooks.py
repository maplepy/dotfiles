import asyncio
import os
import subprocess

from libqtile import hook, qtile
from libqtile.utils import send_notification


@hook.subscribe.client_urgent_hint_changed
def client_urgency_change(client):
    send_notification("qtile", f"{client.name} has changed its urgency state")

@hook.subscribe.client_urgent_hint_changed
def get_ready(client):
    # if its counter strike then focus it
    if client.name == "Counter-Strike: Global Offensive":
        client.group.cmd_toscreen()
        # client.cmd_focus()
    # if client.urgent:
    #     send_notification("qtile", f"{client.name} has changed its urgency state")
    #     client.group.cmd_toscreen()

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

# @hook.subscribe.resume
# def resume():
#     send_notification("qtile", "Resumed")

@hook.subscribe.client_new
async def client_new(client):
    await asyncio.sleep(0.5)
    if client.name == "Spotify":
        client.togroup("0")
