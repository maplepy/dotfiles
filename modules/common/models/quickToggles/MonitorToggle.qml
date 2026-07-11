import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    id: root
    name: Translation.tr("External Monitor")
    tooltipText: Translation.tr("Toggle secondary monitor")

    property var allMonitors: []

    readonly property var secondary: {
        for (var i = 0; i < root.allMonitors.length; i++) {
            if (root.allMonitors[i].id !== 0) return root.allMonitors[i];
        }
        return null;
    }
    available: secondary !== null
    toggled: secondary !== null && !secondary.disabled
    icon: "desktop_windows"
    statusText: toggled ? Translation.tr("On") : Translation.tr("Off")

    mainAction: () => {
        console.log("[MonitorToggle] click! secondary=" + JSON.stringify(secondary) + " toggled=" + toggled);
        if (!secondary) return;
        const cmd = ["hyprctl", "output", secondary.name, toggled ? "disable" : "enable"];
        console.log("[MonitorToggle] running:", cmd.join(" "));
        Quickshell.execDetached(cmd);
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
                const parsed = JSON.parse(allMonitorsCollector.text);
                console.log("[MonitorToggle] monitors all:", allMonitorsCollector.text);
                root.allMonitors = parsed;
                console.log("[MonitorToggle] secondary=", JSON.stringify(root.secondary), "available=", root.available, "toggled=", root.toggled);
            }
        }
    }

    Component.onCompleted: {
        console.log("[MonitorToggle] onCompleted, querying monitors all");
        getAllMonitors.running = true;
    }
}
