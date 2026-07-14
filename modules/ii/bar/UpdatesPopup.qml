import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.services

StyledPopup {
    id: root

    ColumnLayout {
        id: columnLayout

        anchors.centerIn: parent
        spacing: 4

        StyledPopupHeaderRow {
            icon: "system_update"
            label: ("Updates")
        }

        StyledPopupValueRow {
            icon: "package"
            label: ("Available packages:")
            value: Updates.count
        }

        StyledPopupValueRow {
            visible: Updates.checking
            icon: "sync"
            label: ("Status:")
            value: ("Checking...")
        }

    }

}
