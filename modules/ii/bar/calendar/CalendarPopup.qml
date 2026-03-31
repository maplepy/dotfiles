import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.modules.ii.sidebarRight.calendar

PopupWindow {
    id: root

    property real popupBackgroundMargin: 0

    signal menuClosed
    signal menuOpened(qsWindow: var)

    color: "transparent"
    property real padding: Appearance.sizes.elevationMargin

    implicitHeight: popupBackground.implicitHeight + root.padding * 2
    implicitWidth: popupBackground.implicitWidth + root.padding * 2

    function open() {
        root.visible = true;
        root.menuOpened(root);
    }

    function close() {
        root.visible = false;
        root.menuClosed();
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.RightButton
        onPressed: event => {
            if (event.button === Qt.BackButton || event.button === Qt.RightButton)
                root.close();
        }

        StyledRectangularShadow {
            target: popupBackground
            opacity: popupBackground.opacity
        }

        Rectangle {
            id: popupBackground
            readonly property real padding: 10
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: Config.options.bar.vertical ? parent.verticalCenter : undefined
                top: Config.options.bar.vertical ? undefined : Config.options.bar.bottom ? undefined : parent.top
                bottom: Config.options.bar.vertical ? undefined : Config.options.bar.bottom ? parent.bottom : undefined
                margins: root.padding
            }

            color: Appearance.colors.colLayer0
            radius: Appearance.rounding.windowRounding
            border.width: 1
            border.color: Appearance.colors.colLayer0Border
            clip: true

            opacity: 0
            Component.onCompleted: opacity = 1
            implicitWidth: calendarWidget.implicitWidth + popupBackground.padding * 2
            implicitHeight: calendarWidget.implicitHeight + popupBackground.padding * 2

            Behavior on opacity {
                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
            }
            Behavior on implicitHeight {
                animation: Appearance.animation.elementResize.numberAnimation.createObject(this)
            }
            Behavior on implicitWidth {
                animation: Appearance.animation.elementResize.numberAnimation.createObject(this)
            }

            CalendarWidget {
                id: calendarWidget
                anchors.centerIn: parent
                anchors.margins: popupBackground.padding
            }
        }
    }
}
