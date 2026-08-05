import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.ii.bar as Bar
import qs.modules.ii.bar.calendar

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    implicitHeight: clockColumn.implicitHeight
    implicitWidth: Appearance.sizes.verticalBarWidth

    ColumnLayout {
        id: clockColumn
        anchors.centerIn: parent
        spacing: 0

        Repeater {
            model: DateTime.time.split(/[: ]/)
            delegate: StyledText {
                required property string modelData
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: modelData.match(/am|pm/i) ? 
                    Appearance.font.pixelSize.smaller // Smaller "am"/"pm" text
                    : Appearance.font.pixelSize.large
                color: Appearance.colors.colOnLayer1
                text: modelData.padStart(2, "0")
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !Config.options.bar.tooltips.clickToShow
        acceptedButtons: Qt.LeftButton
        
        onClicked: {
            if (calendarMenu.active && calendarMenu.item.visible) {
                calendarMenu.item.close();
            } else {
                calendarMenu.open();
            }
        }

        Bar.ClockWidgetPopup {
            hoverTarget: mouseArea
        }
    }

    Loader {
        id: calendarMenu
        function open() {
            calendarMenu.active = true;
            if (calendarMenu.item) calendarMenu.item.open();
        }
        active: false
        sourceComponent: CalendarPopup {
            Component.onCompleted: this.open();
            anchor {
                window: root.QsWindow.window
                rect.x: root.x + (Config.options.bar.vertical ? 0 : QsWindow.window?.width)
                rect.y: root.y + (Config.options.bar.vertical ? QsWindow.window?.height : 0)
                rect.height: root.height
                rect.width: root.width
                edges: Edges.Top | Edges.Right
                gravity: Edges.Top | Edges.Right
            }
            onMenuClosed: {
                calendarMenu.active = false;
            }
        }
    }
}
