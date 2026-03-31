import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Wayland

WindowDialog {
    id: root
    backgroundHeight: 400

    WindowDialogTitle {
        text: Translation.tr("Keep awake")
    }

    WindowDialogSectionHeader {
        text: Translation.tr("Timer")
    }

    WindowDialogSeparator {
        Layout.topMargin: -22
        Layout.leftMargin: 0
        Layout.rightMargin: 0
    }

    Column {
        id: timerColumn
        Layout.topMargin: -16
        Layout.fillWidth: true
        spacing: 8

        ConfigSwitch {
            anchors {
                left: parent.left
                right: parent.right
            }
            iconSize: Appearance.font.pixelSize.larger
            buttonIcon: "all_inclusive"
            text: Translation.tr("Indefinite")
            checked: Idle.isIndefinite
            onCheckedChanged: {
                Idle.isIndefinite = checked;
            }
        }

        WindowDialogSlider {
            id: durationSlider
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 4
                rightMargin: 4
            }
            visible: !Idle.isIndefinite
            text: Translation.tr("Duration")
            from: 60 // 1 minute
            to: 86400 // 24 hours
            value: Idle.duration
            onMoved: {
                Idle.duration = value;
                if (Idle.inhibit && !Idle.isIndefinite) {
                    Idle.timeRemaining = Idle.duration;
                }
            }
            tooltipContent: {
                let h = Math.floor(value / 3600);
                let m = Math.floor((value % 3600) / 60);
                let res = [];
                if (h > 0) res.push(`${h}h`);
                if (m > 0 || h === 0) res.push(`${m}m`);
                return res.join(" ");
            }
        }

        RowLayout {
            Layout.fillWidth: true
            visible: !Idle.isIndefinite
            spacing: 8
            
            DialogButton {
                Layout.fillWidth: true
                buttonText: "30m"
                onClicked: { Idle.duration = 1800; if (Idle.inhibit && !Idle.isIndefinite) Idle.timeRemaining = Idle.duration; }
            }
            DialogButton {
                Layout.fillWidth: true
                buttonText: "1h"
                onClicked: { Idle.duration = 3600; if (Idle.inhibit && !Idle.isIndefinite) Idle.timeRemaining = Idle.duration; }
            }
            DialogButton {
                Layout.fillWidth: true
                buttonText: "2h"
                onClicked: { Idle.duration = 7200; if (Idle.inhibit && !Idle.isIndefinite) Idle.timeRemaining = Idle.duration; }
            }
            DialogButton {
                Layout.fillWidth: true
                buttonText: "4h"
                onClicked: { Idle.duration = 14400; if (Idle.inhibit && !Idle.isIndefinite) Idle.timeRemaining = Idle.duration; }
            }
        }
    }
    
    Item {
        Layout.fillHeight: true
    }

    WindowDialogButtonRow {
        Layout.fillWidth: true

        Item {
            Layout.fillWidth: true
        }

        DialogButton {
            buttonText: Translation.tr("Done")
            onClicked: root.dismiss()
        }
    }
}
