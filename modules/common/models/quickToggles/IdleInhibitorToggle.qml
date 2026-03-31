import QtQuick
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    name: Translation.tr("Keep awake")

    toggled: Idle.inhibit
    icon: "coffee"
    hasMenu: true
    statusText: {
        if (!toggled) return Translation.tr("Off");
        if (Idle.isIndefinite) return Translation.tr("On");
        return Idle.timeRemainingString;
    }
    mainAction: () => {
        Idle.toggleInhibit()
    }
    tooltipText: Translation.tr("Keep system awake")
}
