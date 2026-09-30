import QtQuick
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets
import qs.services

QuickToggleButton {
    id: nightLightButton

    toggled: Hyprsunset.active
    buttonIcon: {
        if (Hyprsunset.isTransitioning)
            return "schedule";

        if (Config.options.light.night.automatic)
            return "night_sight_auto";

        return "bedtime";
    }
    onClicked: {
        Hyprsunset.toggle();
    }
    altAction: () => {
        Config.options.light.night.automatic = !Config.options.light.night.automatic;
    }
    Component.onCompleted: {
        Hyprsunset.fetchState();
    }

    StyledToolTip {
        text: Hyprsunset.isTransitioning ? ("Night Light | Transitioning (%1K)").arg(Hyprsunset.currentTransitionTemp) : ("Night Light | Right-click to toggle Auto mode")
    }

}
