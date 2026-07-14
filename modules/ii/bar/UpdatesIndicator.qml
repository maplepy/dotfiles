import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

MouseArea {
    id: root

    property color colText

    hoverEnabled: !Config.options.bar.tooltips.clickToShow
    implicitWidth: updatesIcon.implicitWidth
    implicitHeight: Appearance.sizes.barHeight
    visible: Updates.available

    MaterialSymbol {
        id: updatesIcon

        anchors.centerIn: parent
        text: Updates.updateStronglyAdvised ? "system_update" : (Updates.updateAdvised ? "update" : "check_circle")
        iconSize: Appearance.font.pixelSize.larger
        color: Updates.updateStronglyAdvised ? Appearance.m3colors.m3error : (root.colText || Appearance.colors.colOnLayer1)
    }

    UpdatesPopup {
        id: updatesPopup

        hoverTarget: root
    }

}
