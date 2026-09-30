import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    property bool vertical: Config.options.bar.vertical
    property int unfinishedTasks: Todo.list.filter(item => !item.done).length
    implicitWidth: vertical ? Appearance.sizes.verticalBarWidth : rowLayout.implicitWidth
    implicitHeight: vertical ? rowLayout.implicitHeight : Appearance.sizes.barHeight

    GridLayout {
        id: rowLayout
        anchors.centerIn: parent
        columnSpacing: 4
        rowSpacing: 2
        columns: vertical ? 1 : 4

        RowLayout {
            visible: root.unfinishedTasks > 0
            spacing: 2
            Layout.alignment: Qt.AlignHCenter
            
            MaterialSymbol {
                text: "checklist"
                iconSize: Appearance.font.pixelSize.medium
                color: Appearance.colors.colOnLayer1
            }
            StyledText {
                font.pixelSize: vertical ? Appearance.font.pixelSize.medium : Appearance.font.pixelSize.large
                color: Appearance.colors.colOnLayer1
                text: root.unfinishedTasks
            }
        }

        Item {
            visible: root.unfinishedTasks > 0
            Layout.preferredWidth: vertical ? 0 : 6 // Extra space for horizontal
            Layout.preferredHeight: vertical ? 8 : 0 // Extra space for vertical
        }

        MaterialSymbol {
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (!TimerService.pomodoroRunning && TimerService.pomodoroSecondsLeft === TimerService.pomodoroLapDuration) {
                    return "timer"
                }
                if (TimerService.pomodoroLongBreak) return "spa"
                if (TimerService.pomodoroBreak) return "local_cafe"
                return "adjust" // Focus
            }
            iconSize: Appearance.font.pixelSize.medium
            color: TimerService.pomodoroRunning ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            visible: TimerService.pomodoroRunning || TimerService.pomodoroSecondsLeft !== TimerService.pomodoroLapDuration
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.colOnLayer1
            text: {
                let minutes = Math.floor(TimerService.pomodoroSecondsLeft / 60).toString().padStart(2, '0');
                let seconds = Math.floor(TimerService.pomodoroSecondsLeft % 60).toString().padStart(2, '0');
                return vertical ? `${minutes}\n${seconds}` : `${minutes}:${seconds}`;
            }
        }
    }

    StyledToolTip {
        visible: mouseArea.containsMouse && TimerService.activeTask !== ""
        text: ("Focusing on: ") + TimerService.activeTask
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                if (pomodoroMenu.active && pomodoroMenu.item.visible) {
                    pomodoroMenu.item.close();
                } else {
                    pomodoroMenu.open();
                }
            } else if (event.button === Qt.RightButton) {
                TimerService.togglePomodoro();
            } else if (event.button === Qt.MiddleButton) {
                TimerService.resetPomodoro();
            }
        }
    }

    Loader {
        id: pomodoroMenu
        function open() {
            pomodoroMenu.active = true;
            if (pomodoroMenu.item) pomodoroMenu.item.open();
        }
        active: false
        sourceComponent: PomodoroPopup {
            Component.onCompleted: this.open();
            anchor {
                window: root.QsWindow.window
                rect.x: root.x + (Config.options.bar.vertical ? 0 : QsWindow.window?.width)
                rect.y: root.y + (Config.options.bar.vertical ? QsWindow.window?.height : 0)
                rect.height: root.height
                rect.width: root.width
                edges: Config.options.bar.bottom ? (Edges.Top) : (Edges.Bottom)
                gravity: Config.options.bar.bottom ? (Edges.Top) : (Edges.Bottom)
            }
            onMenuClosed: {
                pomodoroMenu.active = false;
            }
        }
    }
}
