import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    id: root

    readonly property string monitorDesc: "desc:Ancor Communications Inc VG248 G3LMQS013154"
    readonly property string monitorDisable: monitorDesc + ", disable"
    readonly property string monitorEnable: monitorDesc + ", highres@highrr, 3440x0, 1"

    property var allMonitors: []
    property bool toggled: false

    readonly property var secondary: {
        for (var i = 0; i < root.allMonitors.length; i++) {
            if (root.allMonitors[i].id !== 0) return root.allMonitors[i];
        }
        return null;
    }

    name: "External Monitor"
    tooltipText: "Toggle secondary monitor"
    available: secondary !== null
    icon: "desktop_windows"
    statusText: toggled ? "On" : "Off"

    mainAction: () => {
        if (!secondary) return;
        root.toggled = !root.toggled;  // ponytail: instant UI flip, ground truth from re-query
        const params = root.toggled ? root.monitorEnable : root.monitorDisable;
        Quickshell.execDetached(["hyprctl", "keyword", "monitor", params]);
        refreshTimer.start();
    }

    Timer {
        id: refreshTimer
        interval: 500
        onTriggered: getAllMonitors.running = true
    }

    Process {
        id: getAllMonitors
        command: ["hyprctl", "monitors", "all", "-j"]
        stdout: StdioCollector {
            id: allMonitorsCollector
            onStreamFinished: {
                root.allMonitors = JSON.parse(allMonitorsCollector.text);
                if (root.secondary) {
                    root.toggled = !root.secondary.disabled;
                }
            }
        }
    }

    Component.onCompleted: getAllMonitors.running = true
}
