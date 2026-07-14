import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root

    property alias title: title.text
    property alias value: value.text
    property alias symbol: symbol.text
    property string accentColor: "default"

    function getAccentColor(accent) {
        switch (accent) {
        case "success":
            return Appearance.m3colors.m3success;
        case "error":
            return Appearance.m3colors.m3error;
        case "primary":
            return Appearance.m3colors.m3primary;
        case "tertiary":
            return Appearance.m3colors.m3tertiary;
        default:
            return Appearance.colors.colOnSurfaceVariant;
        }
    }

    radius: Appearance.rounding.small
    color: Appearance.colors.colSurfaceContainerHigh
    implicitWidth: columnLayout.implicitWidth + 14 * 2
    implicitHeight: columnLayout.implicitHeight + 14 * 2
    Layout.fillWidth: parent

    ColumnLayout {
        id: columnLayout

        anchors.fill: parent
        spacing: -10

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            MaterialSymbol {
                id: symbol

                fill: 0
                iconSize: Appearance.font.pixelSize.normal
                color: getAccentColor(accentColor)
            }

            StyledText {
                id: title

                font.pixelSize: Appearance.font.pixelSize.smaller
                color: getAccentColor(accentColor)
            }

        }

        StyledText {
            id: value

            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.small
            font.weight: accentColor !== "default" ? Font.Bold : Font.Normal
            color: getAccentColor(accentColor)
        }

    }

}
