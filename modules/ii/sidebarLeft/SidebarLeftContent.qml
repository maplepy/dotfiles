import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    required property var scopeRoot

    anchors.fill: parent

    StyledText {
        anchors.centerIn: parent
        text: "Enjoy your empty sidebar..."
        color: Appearance.colors.colSubtext
    }

}
