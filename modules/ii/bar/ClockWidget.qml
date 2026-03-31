import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.ii.bar.calendar

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    property bool showDate: Config.options.bar.verbose
    property int unfinishedTasks: Todo.list.filter(item => !item.done).length
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.sizes.barHeight

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4

        RowLayout {
            visible: root.unfinishedTasks > 0
            spacing: 2
            MaterialSymbol {
                text: "checklist"
                iconSize: Appearance.font.pixelSize.medium
                color: Appearance.colors.colOnLayer1
            }
            StyledText {
                font.pixelSize: Appearance.font.pixelSize.large
                color: Appearance.colors.colOnLayer1
                text: root.unfinishedTasks
            }
        }

        StyledText {
            visible: root.unfinishedTasks > 0
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnLayer1
            text: "•"
        }

        StyledText {
            font.pixelSize: Appearance.font.pixelSize.large
            color: Appearance.colors.colOnLayer1
            text: DateTime.time
        }

        StyledText {
            visible: root.showDate
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnLayer1
            text: "•"
        }

        StyledText {
            visible: root.showDate
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnLayer1
            text: DateTime.longDate
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

        ClockWidgetPopup {
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
                edges: Config.options.bar.bottom ? (Edges.Top) : (Edges.Bottom)
                gravity: Config.options.bar.bottom ? (Edges.Top) : (Edges.Bottom)
            }
            onMenuClosed: {
                calendarMenu.active = false;
            }
        }
    }
}

