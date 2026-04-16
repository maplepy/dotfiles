import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell.Io

QuickToggleButton {
    id: nightLightButton
    toggled: Hyprsunset.active
    buttonIcon: {
        if (Hyprsunset.isTransitioning) return "schedule"
        if (Config.options.light.night.automatic) return "night_sight_auto"
        return "bedtime"
    }
    onClicked: {
        Hyprsunset.toggle()
    }

    altAction: () => {
        Config.options.light.night.automatic = !Config.options.light.night.automatic
    }

    Component.onCompleted: {
        Hyprsunset.fetchState()
    }
    
    StyledToolTip {
        text: Hyprsunset.isTransitioning 
            ? Translation.tr("Night Light | Transitioning (%1K)")
            .arg(Hyprsunset.currentTransitionTemp)
            : Translation.tr("Night Light | Right-click to toggle Auto mode")
    }
}
