import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

LazyLoader {
    id: root
    property Item hoverTarget

    active: hoverTarget && hoverTarget.containsMouse

    function getUpcomingTodos() {
        const unfinishedTodos = Todo.list.filter(function (item) {
            return !item.done;
        });
        if (unfinishedTodos.length === 0) {
            return ("No pending tasks");
        }

        const limitedTodos = unfinishedTodos.slice(0, 5);
        let todoText = limitedTodos.map(function (item, index) {
            return `  ${index + 1}. ${item.content}`;
        }).join('\n');

        if (unfinishedTodos.length > 5) {
            todoText += `\n  ${("... and %1 more").arg(unfinishedTodos.length - 5)}`;
        }

        return todoText;
    }

    component: PanelWindow {
        color: "transparent"

        anchors.left: !Config.options.bar.vertical || (Config.options.bar.vertical && !Config.options.bar.bottom)
        anchors.right: Config.options.bar.vertical && Config.options.bar.bottom
        anchors.top: Config.options.bar.vertical || (!Config.options.bar.vertical && !Config.options.bar.bottom)
        anchors.bottom: !Config.options.bar.vertical && Config.options.bar.bottom

        implicitWidth: popupBackground.implicitWidth + 20
        implicitHeight: popupBackground.implicitHeight + 20

        mask: Region {
            item: popupBackground
        }

        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        margins {
            left: {
                if (!Config.options.bar.vertical) return root.QsWindow?.mapFromItem(
                    root.hoverTarget,
                    (root.hoverTarget.width - popupBackground.implicitWidth) / 2, 0
                ).x;
                return Appearance.sizes.verticalBarWidth
            }
            top: {
                if (!Config.options.bar.vertical) return Appearance.sizes.barHeight;
                return root.QsWindow?.mapFromItem(
                    root.hoverTarget,
                    (root.hoverTarget.height - popupBackground.implicitHeight) / 2, 0
                ).y;
            }
            right: Appearance.sizes.verticalBarWidth
            bottom: Appearance.sizes.barHeight
        }
        WlrLayershell.namespace: "quickshell:popup"
        WlrLayershell.layer: WlrLayer.Overlay

        Rectangle {
            id: popupBackground
            readonly property real margin: 10
            anchors {
                fill: parent
                leftMargin: margin
                rightMargin: margin
                topMargin: margin
                bottomMargin: margin
            }
            implicitWidth: columnLayout.implicitWidth + margin * 2
            implicitHeight: columnLayout.implicitHeight + margin * 2
            color: Appearance.m3colors.m3surfaceContainer
            radius: Appearance.rounding.small
            border.width: 1
            border.color: Appearance.colors.colLayer0Border

            ColumnLayout {
                id: columnLayout
                anchors.centerIn: parent
                spacing: 4

                Row {
                    spacing: 5
                    MaterialSymbol {
                        anchors.verticalCenter: parent.verticalCenter
                        fill: 0
                        font.weight: Font.DemiBold
                        text: "checklist"
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnSurfaceVariant
                    }
                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ("To Do:")
                        font {
                            weight: Font.DemiBold
                            pixelSize: Appearance.font.pixelSize.normal
                        }
                        color: Appearance.colors.colOnSurfaceVariant
                    }
                }

                StyledText {
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.Wrap
                    color: Appearance.colors.colOnSurfaceVariant
                    text: root.getUpcomingTodos()
                }
            }
        }
    }
}