import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    id: root

    readonly property string monitorDesc: "desc:Ancor Communications Inc VG248 G3LMQS013154"
    // ponytail: hyprctl keyword doesn't work under hyprland.lua ("keyword can't work
    // with non-legacy parsers. Use eval."), so we build lua hl.monitor(...) calls and
    // send them via `hyprctl eval` instead. Legacy Hyprland.usingLua==false path kept
    // for rollback safety.
    readonly property string monitorDisableLegacy: monitorDesc + ", disable"
    readonly property string monitorEnableLegacy: monitorDesc + ", highres@highrr, 3440x0, 1"
    readonly property string monitorDisableLua: "hl.monitor({output=\"" + monitorDesc + "\", disabled=true})"
    readonly property string monitorEnableLua: "hl.monitor({output=\"" + monitorDesc + "\", mode=\"highres@highrr\", position=\"3440x0\", scale=1, disabled=false})"

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
        if (Hyprland.usingLua) {
            const luaExpr = root.toggled ? root.monitorEnableLua : root.monitorDisableLua;
            Quickshell.execDetached(["hyprctl", "eval", luaExpr]);
        } else {
            const params = root.toggled ? root.monitorEnableLegacy : root.monitorDisableLegacy;
            Quickshell.execDetached(["hyprctl", "keyword", "monitor", params]);
        }
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
