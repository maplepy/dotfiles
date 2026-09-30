import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.common.widgets
import qs.services

MouseArea {
    id: root

    property color colText

    hoverEnabled: !Config.options.bar.tooltips.clickToShow
    implicitWidth: updatesIcon.implicitWidth
    implicitHeight: Appearance.sizes.barHeight
    visible: Updates.available && Updates.count > 0

    onClicked: Quickshell.execDetached(["bash", "-c", Config.options.apps.update])

    MaterialSymbol {
        id: updatesIcon

        anchors.centerIn: parent
        text: Updates.updateStronglyAdvised ? "system_update" : (Updates.updateAdvised ? "update" : "check_circle")
        iconSize: Appearance.font.pixelSize.larger
        color: Updates.updateStronglyAdvised ? Appearance.m3colors.m3error : (root.colText || Appearance.colors.colOnLayer2)
    }

    UpdatesPopup {
        id: updatesPopup

        hoverTarget: root
    }

}
