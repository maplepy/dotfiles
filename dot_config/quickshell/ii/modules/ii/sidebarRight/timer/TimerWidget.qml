import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.ii.sidebarRight.timer
import qs.services

Item {
    id: root

    property var tabButtonList: [{
        "name": ("Timer"),
        "icon": "timer"
    }, {
        "name": ("Stopwatch"),
        "icon": "stopwatch"
    }]

    Keys.onPressed: (event) => {
        if ((event.key === Qt.Key_PageDown || event.key === Qt.Key_PageUp) && event.modifiers === Qt.NoModifier) {
            if (event.key === Qt.Key_PageDown)
                tabBar.incrementCurrentIndex();
            else if (event.key === Qt.Key_PageUp)
                tabBar.decrementCurrentIndex();
            event.accepted = true;
        } else if (event.key === Qt.Key_Space || event.key === Qt.Key_S) {
            if (tabBar.currentIndex === 0) {
                if (TimerService.countdownRunning)
                    TimerService.pauseCountdown();
                else
                    TimerService.startCountdown();
            } else {
                TimerService.toggleStopwatch();
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_R) {
            if (tabBar.currentIndex === 0)
                TimerService.resetCountdown();
            else
                TimerService.stopwatchReset();
            event.accepted = true;
        } else if (event.key === Qt.Key_L && tabBar.currentIndex === 1) {
            TimerService.stopwatchRecordLap();
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        SecondaryTabBar {
            id: tabBar

            currentIndex: swipeView.currentIndex

            Repeater {
                model: root.tabButtonList

                delegate: SecondaryTabButton {
                    buttonText: modelData.name
                    buttonIcon: modelData.icon
                }

            }

        }

        SwipeView {
            id: swipeView

            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5
            clip: true
            currentIndex: tabBar.currentIndex

            CountdownTimer {
            }

            Stopwatch {
            }

        }

    }

}
