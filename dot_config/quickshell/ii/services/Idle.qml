import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common
pragma Singleton

/**
 * A nice wrapper for date and time strings.
 */
Singleton {
    id: root

    property alias inhibit: idleInhibitor.enabled
    property int duration: 7200 // 2 hours by default
    property int timeRemaining: 0
    property bool isIndefinite: false
    property string timeRemainingString: {
        if (isIndefinite || !inhibit)
            return "";

        let h = Math.floor(timeRemaining / 3600);
        let m = Math.floor((timeRemaining % 3600) / 60);
        let s = timeRemaining % 60;
        if (h > 0)
            return `${h}h ${m}m`;

        return `${m}m ${s}s`;
    }

    function toggleInhibit(active = null) {
        if (active !== null)
            root.inhibit = active;
        else
            root.inhibit = !root.inhibit;
        if (root.inhibit && !root.isIndefinite)
            root.timeRemaining = root.duration;

        Persistent.states.idle.inhibit = root.inhibit;
    }

    inhibit: false

    Timer {
        id: inhibitTimer

        interval: 1000
        running: root.inhibit && !root.isIndefinite
        repeat: true
        onTriggered: {
            if (root.timeRemaining > 0)
                root.timeRemaining -= 1;
            else
                root.toggleInhibit(false);
        }
    }

    Connections {
        function onReadyChanged() {
            if (!Persistent.isNewHyprlandInstance)
                root.inhibit = Persistent.states.idle.inhibit;
            else
                Persistent.states.idle.inhibit = root.inhibit;
        }

        target: Persistent
    }

    IdleInhibitor {
        id: idleInhibitor

        window: PanelWindow {
            // Inhibitor requires a "visible" surface
            // Actually not lol
            implicitWidth: 0
            implicitHeight: 0
            color: "transparent"

            // Just in case...
            anchors {
                right: true
                bottom: true
            }

            // Make it not interactable
            mask: Region {
                item: null
            }

        }

    }

}
