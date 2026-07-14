import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.ii.bar as Bar
import qs.services

// Full hitbox
Item {
    id: root

    property var dayOfMonth: DateTime.shortDate.split(/[-\/]/)[0] // What if 🍔murica🦅? good question
    property var monthOfYear: DateTime.shortDate.split(/[-\/]/)[1]

    implicitHeight: content.implicitHeight
    implicitWidth: Appearance.sizes.verticalBarWidth

    // Boundaries for date numbers
    Item {
        id: content

        anchors.centerIn: parent
        implicitWidth: 24
        implicitHeight: 30

        Shape {
            id: diagonalLine

            property real padding: 4

            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeWidth: 1.2
                strokeColor: Appearance.colors.colSubtext
                fillColor: "transparent"
                startX: content.width - diagonalLine.padding
                startY: diagonalLine.padding

                PathLine {
                    x: diagonalLine.padding
                    y: content.height - diagonalLine.padding
                }

            }

        }

        StyledText {
            id: dayText

            font.pixelSize: 13
            color: Appearance.colors.colOnLayer1
            text: dayOfMonth

            anchors {
                top: parent.top
                left: parent.left
            }

        }

        StyledText {
            id: monthText

            font.pixelSize: 13
            color: Appearance.colors.colOnLayer1
            text: monthOfYear

            anchors {
                bottom: parent.bottom
                right: parent.right
            }

        }

    }

}
