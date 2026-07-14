import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
        spacing: 10

        // The timer circle
        CircularProgress {
            Layout.alignment: Qt.AlignHCenter
            lineWidth: 6
            value: TimerService.countdownDuration > 0 ? TimerService.countdownRemaining / TimerService.countdownDuration : 0
            implicitSize: 150
            enableAnimation: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                        let minutes = Math.floor(TimerService.countdownRemaining / 60).toString().padStart(2, '0');
                        let seconds = Math.floor(TimerService.countdownRemaining % 60).toString().padStart(2, '0');
                        return `${minutes}:${seconds}`;
                    }
                    font.pixelSize: 28
                    color: Appearance.m3colors.m3onSurface
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: TimerService.countdownRunning ? ("Running") : ("Ready")
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colSubtext
                }

            }

            Rectangle {
                radius: Appearance.rounding.full
                color: Appearance.colors.colLayer2
                implicitWidth: 28
                implicitHeight: implicitWidth

                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }

                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer2
                    text: Math.floor(TimerService.countdownDuration / 60)
                }

            }

        }

        // The Start/Stop and Reset buttons
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            RippleButton {
                implicitHeight: 28
                implicitWidth: 70
                font.pixelSize: Appearance.font.pixelSize.normal
                onClicked: {
                    if (TimerService.countdownRunning)
                        TimerService.pauseCountdown();
                    else
                        TimerService.startCountdown();
                }
                colBackground: TimerService.countdownRunning ? Appearance.colors.colSecondaryContainer : Appearance.colors.colPrimary
                colBackgroundHover: TimerService.countdownRunning ? Appearance.colors.colSecondaryContainer : Appearance.colors.colPrimary

                contentItem: StyledText {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: TimerService.countdownRunning ? ("Pause") : (TimerService.countdownRemaining === TimerService.countdownDuration) ? ("Start") : ("Resume")
                    color: TimerService.countdownRunning ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnPrimary
                }

            }

            RippleButton {
                implicitHeight: 28
                implicitWidth: 70
                onClicked: TimerService.resetCountdown()
                enabled: TimerService.countdownRemaining < TimerService.countdownDuration
                font.pixelSize: Appearance.font.pixelSize.normal
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

        // Duration Presets
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 5
            spacing: 8

            RippleButton {
                implicitHeight: 28
                implicitWidth: 50
                buttonRadius: Appearance.rounding.small
                onClicked: TimerService.setCountdownDuration(60)
                colBackgroundHover: Appearance.colors.colLayer1Hover

                contentItem: StyledText {
                    anchors.centerIn: parent
                    text: "1m"
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                }

            }

            RippleButton {
                implicitHeight: 28
                implicitWidth: 50
                buttonRadius: Appearance.rounding.small
                onClicked: TimerService.setCountdownDuration(300)
                colBackgroundHover: Appearance.colors.colLayer1Hover

                contentItem: StyledText {
                    anchors.centerIn: parent
                    text: "5m"
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                }

            }

            RippleButton {
                implicitHeight: 28
                implicitWidth: 50
                buttonRadius: Appearance.rounding.small
                onClicked: TimerService.setCountdownDuration(600)
                colBackgroundHover: Appearance.colors.colLayer1Hover

                contentItem: StyledText {
                    anchors.centerIn: parent
                    text: "10m"
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                }

            }

            RippleButton {
                implicitHeight: 28
                implicitWidth: 50
                buttonRadius: Appearance.rounding.small
                onClicked: TimerService.setCountdownDuration(1800)
                colBackgroundHover: Appearance.colors.colLayer1Hover

                contentItem: StyledText {
                    anchors.centerIn: parent
                    text: "30m"
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                }

            }

            RippleButton {
                implicitHeight: 28
                implicitWidth: 50
                buttonRadius: Appearance.rounding.small
                onClicked: TimerService.setCountdownDuration(3600)
                colBackgroundHover: Appearance.colors.colLayer1Hover

                contentItem: StyledText {
                    anchors.centerIn: parent
                    text: "1h"
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                }

            }

        }

        // Time Adjuster
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 5
            spacing: 6

            RippleButton {
                implicitWidth: 24
                implicitHeight: 24
                buttonRadius: Appearance.rounding.small
                onClicked: TimerService.addCountdownTime(-60)

                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    text: "remove"
                    iconSize: 14
                    color: Appearance.colors.colOnLayer1
                }

            }

            StyledText {
                text: Math.floor(TimerService.countdownDuration / 60) + "m"
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colOnLayer0
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 35
            }

            RippleButton {
                implicitWidth: 24
                implicitHeight: 24
                buttonRadius: Appearance.rounding.small
                onClicked: TimerService.addCountdownTime(60)

                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    text: "add"
                    iconSize: 14
                    color: Appearance.colors.colOnLayer1
                }

            }

        }

    }

}
