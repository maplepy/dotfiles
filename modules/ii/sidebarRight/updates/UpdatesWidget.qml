import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_R && event.modifiers === Qt.NoModifier) {
            Updates.refresh();
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            MaterialSymbol {
                text: "system_update"
                iconSize: Appearance.font.pixelSize.huge
                color: Updates.updateStronglyAdvised ? Appearance.m3colors.m3error : (Updates.updateAdvised ? Appearance.m3colors.m3tertiary : Appearance.m3colors.m3onSurface)
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                StyledText {
                    text: Updates.checking ? ("Checking...") : (Updates.updateStronglyAdvised ? ("System update strongly advised") : (Updates.updateAdvised ? ("System update available") : ("System is up to date")))
                    font.pixelSize: Appearance.font.pixelSize.larger
                    color: Appearance.m3colors.m3onSurface
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                StyledText {
                    visible: Updates.available
                    text: ("%1 package%2 can be updated").arg(Updates.count).arg(Updates.count === 1 ? "" : "s")
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3onSurfaceVariant
                }

                StyledText {
                    visible: !Updates.available && !Updates.checking
                    text: ("checkupdates is not installed")
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3onSurfaceVariant
                }

            }

        }

        RippleButton {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            buttonRadius: Appearance.rounding.normal
            colBackground: Appearance.m3colors.m3primaryContainer
            enabled: Updates.available
            onClicked: {
                Quickshell.execDetached(["bash", "-c", Config.options.apps.update]);
            }

            contentItem: Item {
                anchors.centerIn: parent

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    MaterialSymbol {
                        text: "terminal"
                        iconSize: Appearance.font.pixelSize.normal
                        color: Appearance.m3colors.m3onPrimaryContainer
                    }

                    StyledText {
                        text: ("Open update terminal")
                        color: Appearance.m3colors.m3onPrimaryContainer
                        font.pixelSize: Appearance.font.pixelSize.normal
                    }

                }

            }

        }

        RippleButton {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            buttonRadius: Appearance.rounding.normal
            colBackground: Appearance.m3colors.m3secondaryContainer
            enabled: !Updates.checking
            onClicked: Updates.refresh()

            contentItem: Item {
                anchors.centerIn: parent

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    MaterialSymbol {
                        text: "sync"
                        iconSize: Appearance.font.pixelSize.normal
                        color: Appearance.m3colors.m3onSecondaryContainer
                    }

                    StyledText {
                        text: ("Refresh")
                        color: Appearance.m3colors.m3onSecondaryContainer
                        font.pixelSize: Appearance.font.pixelSize.normal
                    }

                }

            }

        }

    }

}
