import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.ii.sidebarRight.pomodoro
import qs.modules.ii.sidebarRight.todo
import qs.services

PopupWindow {
    id: root

    property real popupBackgroundMargin: 0
    property real padding: Appearance.sizes.elevationMargin

    signal menuClosed()
    signal menuOpened(var qsWindow)

    function open() {
        root.visible = true;
        root.menuOpened(root);
        GlobalFocusGrab.addDismissable(root);
    }

    function close() {
        root.visible = false;
        GlobalFocusGrab.removeDismissable(root);
        root.menuClosed();
    }

    color: "transparent"
    implicitHeight: popupBackground.implicitHeight + root.padding * 2
    implicitWidth: popupBackground.implicitWidth + root.padding * 2

    Connections {
        function onDismissed() {
            root.close();
        }

        target: GlobalFocusGrab
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.RightButton
        onPressed: (event) => {
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

            color: Appearance.colors.colLayer0
            radius: Appearance.rounding.windowRounding
            border.width: 1
            border.color: Appearance.colors.colLayer0Border
            clip: true
            opacity: 0
            Component.onCompleted: opacity = 1
            implicitWidth: popupContentLayout.implicitWidth + popupBackground.padding * 2
            implicitHeight: popupContentLayout.implicitHeight + popupBackground.padding * 2

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: Config.options.bar.vertical ? parent.verticalCenter : undefined
                top: Config.options.bar.vertical ? undefined : Config.options.bar.bottom ? undefined : parent.top
                bottom: Config.options.bar.vertical ? undefined : Config.options.bar.bottom ? parent.bottom : undefined
                margins: root.padding
            }

            RowLayout {
                id: popupContentLayout

                anchors.centerIn: parent
                anchors.margins: popupBackground.padding
                spacing: 16

                TodoWidget {
                    id: todoWidget

                    Layout.preferredWidth: 350
                    Layout.fillHeight: true
                    Layout.minimumHeight: pomodoroWidget.Layout.preferredHeight
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true
                    color: Appearance.colors.colLayer0Border
                }

                PomodoroWidget {
                    id: pomodoroWidget

                    Layout.preferredWidth: 340
                    Layout.preferredHeight: TimerService.activeTask !== "" ? 450 : 380

                    Behavior on Layout.preferredHeight {
                        NumberAnimation {
                            duration: Appearance.animation.elementMoveFast.duration
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                        }

                    }

                }

            }

            Behavior on opacity {
                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
            }

            Behavior on implicitHeight {
                animation: Appearance.animation.elementResize.numberAnimation.createObject(this)
            }

            Behavior on implicitWidth {
                animation: Appearance.animation.elementResize.numberAnimation.createObject(this)
            }

        }

    }

}
