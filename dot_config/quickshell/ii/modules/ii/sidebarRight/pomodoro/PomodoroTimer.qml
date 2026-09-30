import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.modules.common.widgets
import qs.services

Item {
    id: root

    implicitHeight: contentColumn.implicitHeight
    implicitWidth: contentColumn.implicitWidth

    ColumnLayout {
        id: contentColumn

        anchors.fill: parent
        spacing: 16

        // Active Task Display
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.maximumWidth: 250
            visible: TimerService.activeTask !== ""
            spacing: 5

            MaterialSymbol {
                text: "adjust" // Or another focus icon
                iconSize: Appearance.font.pixelSize.large
                color: Appearance.colors.colPrimary
            }

            StyledText {
                Layout.fillWidth: true
                text: TimerService.activeTask
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.m3colors.m3onSurface
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            RippleButton {
                implicitHeight: 24
                implicitWidth: 24
                buttonRadius: Appearance.rounding.full
                onClicked: TimerService.clearActiveTask()

                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    text: "close"
                    iconSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                }

            }

        }

        // The Pomodoro timer circle
        CircularProgress {
            Layout.alignment: Qt.AlignHCenter
            lineWidth: 8
            value: {
                return TimerService.pomodoroSecondsLeft / TimerService.pomodoroLapDuration;
            }
            implicitSize: 200
            enableAnimation: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                        let minutes = Math.floor(TimerService.pomodoroSecondsLeft / 60).toString().padStart(2, '0');
                        let seconds = Math.floor(TimerService.pomodoroSecondsLeft % 60).toString().padStart(2, '0');
                        return `${minutes}:${seconds}`;
                    }
                    font.pixelSize: 40
                    color: Appearance.m3colors.m3onSurface
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: TimerService.pomodoroLongBreak ? ("Long break") : TimerService.pomodoroBreak ? ("Break") : ("Focus")
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colSubtext
                }

            }

            Rectangle {
                radius: Appearance.rounding.full
                color: Appearance.colors.colLayer2
                implicitWidth: 36
                implicitHeight: implicitWidth

                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }

                StyledText {
                    id: cycleText

                    anchors.centerIn: parent
                    color: Appearance.colors.colOnLayer2
                    text: TimerService.pomodoroCycle + 1
                }

            }

        }

        // The Start/Stop and Reset buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            RippleButton {
                implicitHeight: 35
                implicitWidth: 90
                font.pixelSize: Appearance.font.pixelSize.larger
                onClicked: TimerService.togglePomodoro()
                colBackground: TimerService.pomodoroRunning ? Appearance.colors.colSecondaryContainer : Appearance.colors.colPrimary
                colBackgroundHover: TimerService.pomodoroRunning ? Appearance.colors.colSecondaryContainer : Appearance.colors.colPrimary

                contentItem: StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: TimerService.pomodoroRunning ? ("Pause") : (TimerService.pomodoroSecondsLeft === TimerService.pomodoroLapDuration) ? ("Start") : ("Resume")
                    color: TimerService.pomodoroRunning ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnPrimary
                }

            }

            RippleButton {
                implicitHeight: 35
                implicitWidth: 90
                onClicked: TimerService.resetPomodoro()
                enabled: (TimerService.pomodoroSecondsLeft < TimerService.pomodoroLapDuration) || TimerService.pomodoroCycle > 0 || TimerService.pomodoroBreak
                font.pixelSize: Appearance.font.pixelSize.larger
                colBackground: Appearance.colors.colErrorContainer
                colBackgroundHover: Appearance.colors.colErrorContainerHover
                colRipple: Appearance.colors.colErrorContainerActive

                contentItem: StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: ("Reset")
                    color: Appearance.colors.colOnErrorContainer
                }

            }

        }

        // Duration Adjusters
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
            spacing: 20

            TimeAdjuster {
                label: ("Focus")
                timeVal: TimerService.focusTime
                onChange: (delta) => {
                    return TimerService.changeFocusTime(delta);
                }
                onSkip: () => {
                    return TimerService.forceFocus();
                }
            }

            TimeAdjuster {
                label: ("Break")
                timeVal: TimerService.breakTime
                onChange: (delta) => {
                    return TimerService.changeBreakTime(delta);
                }
                onSkip: () => {
                    return TimerService.forceBreak();
                }
            }

            TimeAdjuster {
                label: ("Long")
                timeVal: TimerService.longBreakTime
                onChange: (delta) => {
                    return TimerService.changeLongBreakTime(delta);
                }
                onSkip: () => {
                    return TimerService.forceLongBreak();
                }
            }

            component TimeAdjuster: ColumnLayout {
                property string label
                property int timeVal
                property var onChange
                property var onSkip

                spacing: 5

                RippleButton {
                    Layout.alignment: Qt.AlignHCenter
                    implicitHeight: 24
                    implicitWidth: 60
                    buttonRadius: Appearance.rounding.small
                    onClicked: onSkip()
                    colBackgroundHover: Appearance.colors.colLayer1Hover

                    StyledToolTip {
                        text: ("Click to skip to this phase")
                    }

                    contentItem: StyledText {
                        anchors.centerIn: parent
                        text: label
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: Appearance.colors.colSubtext
                    }

                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5

                    RippleButton {
                        implicitWidth: 24
                        implicitHeight: 24
                        buttonRadius: Appearance.rounding.small
                        onClicked: onChange(-60)

                        contentItem: MaterialSymbol {
                            anchors.centerIn: parent
                            text: "remove"
                            iconSize: Appearance.font.pixelSize.small
                            color: Appearance.colors.colOnLayer1
                        }

                    }

                    StyledText {
                        text: Math.floor(timeVal / 60) + "m"
                        font.pixelSize: Appearance.font.pixelSize.normal
                        color: Appearance.colors.colOnLayer0
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 35
                    }

                    RippleButton {
                        implicitWidth: 24
                        implicitHeight: 24
                        buttonRadius: Appearance.rounding.small
                        onClicked: onChange(60)

                        contentItem: MaterialSymbol {
                            anchors.centerIn: parent
                            text: "add"
                            iconSize: Appearance.font.pixelSize.small
                            color: Appearance.colors.colOnLayer1
                        }

                    }

                }

            }

        }

    }

}
