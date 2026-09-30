//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
// Remove two slashes below and adjust the value to change the UI scale
////@ pragma Env QT_SCALE_FACTOR=1

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "modules/common"
import "panelFamilies"
import "services"

ShellRoot {
    id: root

    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme();
        Hyprsunset.load();
        ConflictKiller.load();
        Wallpapers.load();
        Updates.load();
    }

    ReloadPopup {
    }

    LazyLoader {
        active: Config.ready

        component: IllogicalImpulseFamily {
        }

    }

}
