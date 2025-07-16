import dbus
import dbus.mainloop.glib
from gi.repository import GLib

def on_action_invoked(notification_id, action_key):
    print(f"Action invoked: {action_key}")
    if action_key == 'reply':
        print("Reply action triggered. (But swaync does not send the reply text via ActionInvoked; see below)")

def on_action_invoked_with_reply(notification_id, action_key, reply_text=None):
    print(f"Action: {action_key}")
    if reply_text:
        print(f"Reply text: {reply_text}")
    else:
        print("No reply text received (swaync may not emit it via DBus)")

def main():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    session_bus = dbus.SessionBus()
    notify_object = session_bus.get_object("org.freedesktop.Notifications", "/org/freedesktop/Notifications")
    notify_interface = dbus.Interface(notify_object, "org.freedesktop.Notifications")

    # Listen for ActionInvoked signal
    session_bus.add_signal_receiver(
        on_action_invoked,
        signal_name="ActionInvoked",
        dbus_interface="org.freedesktop.Notifications"
    )

    # Send notification with reply action and input field
    notify_interface.Notify(
        "swaync-test", 0, "", "Fake Reply Test", "Type your reply below:",
        ["reply", "Reply"],  # actions
        {"input": "Type here..."},  # hints
        60000  # expire timeout (ms)
    )

    print("Notification sent. Please reply in the notification pop-up.")
    GLib.MainLoop().run()

if __name__ == "__main__":
    main()
