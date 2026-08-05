import QtQuick
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.services

QuickToggleModel {
    name: ("Anti-flashbang")
    tooltipText: ("Anti-flashbang")
    icon: "flash_off"
    toggled: Config.options.light.antiFlashbang.enable
    mainAction: () => {
        Config.options.light.antiFlashbang.enable = !Config.options.light.antiFlashbang.enable;
    }
    hasMenu: true
}
