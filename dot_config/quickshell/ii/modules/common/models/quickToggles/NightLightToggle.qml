import QtQuick
import Quickshell
import qs
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.services

QuickToggleModel {
    property bool auto: Config.options.light.night.automatic

    name: ("Night Light")
    statusText: Hyprsunset.isTransitioning ? ("Transitioning (%1K)").arg(Hyprsunset.currentTransitionTemp) : (auto ? ("Auto, ") : "") + (toggled ? ("Active") : ("Inactive"))
    toggled: Hyprsunset.active
    icon: Hyprsunset.isTransitioning ? "schedule" : auto ? "night_sight_auto" : "bedtime"
    mainAction: () => {
        Hyprsunset.toggle();
    }
    hasMenu: true
    Component.onCompleted: {
        Hyprsunset.fetchState();
    }
    tooltipText: ("Night Light | Right-click to configure")
}
