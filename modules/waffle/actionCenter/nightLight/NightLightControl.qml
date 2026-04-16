import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Bluetooth
import qs
import qs.services
import qs.services.network
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.modules.waffle.looks
import qs.modules.waffle.actionCenter

Item {
    id: root

    Component.onCompleted: {
        if (Bluetooth.defaultAdapter.enabled)
            Bluetooth.defaultAdapter.discovering = true;
    }
    Component.onDestruction: {
        Bluetooth.defaultAdapter.discovering = false;
    }

    WPanelPageColumn {
        anchors.fill: parent

        BodyRectangle {
            implicitHeight: 400
            implicitWidth: 50

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4

                HeaderRow {
                    id: headerRow
                    Layout.fillWidth: true
                    title: Translation.tr("Eye protection")
                }

                StyledFlickable {
                    id: flickable
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    contentHeight: contentLayout.implicitHeight
                    contentWidth: width
                    clip: true

                    bottomMargin: 12

                    NightLightOptions {
                        id: contentLayout
                        width: flickable.width
                    }
                }
            }
        }

        WPanelSeparator {}

        FooterRectangle {}
    }

    component NightLightOptions: ColumnLayout {
        spacing: 10

        SectionText {
            text: Translation.tr("Night Light")
        }

        ToggleItem {
            name: Translation.tr("Automatic")
            description: Translation.tr("Turn on from sunset to sunrise")
            iconName: "auto"
            checked: Config.options.light.night.automatic
            onCheckedChanged: {
                Config.options.light.night.automatic = checked;
            }
        }

        ToggleItem {
            name: Translation.tr("Use sun schedule")
            description: Translation.tr("Use weather sunset/sunrise times")
            iconName: "schedule"
            checked: Config.options.light.night.useSunSchedule ?? true
            onCheckedChanged: {
                Config.options.light.night.useSunSchedule = checked;
            }
        }

        TransitionSlider {
            Layout.fillWidth: true
            label: Translation.tr("Start early")
            suffix: Translation.tr("min")
            from: 0
            to: 60
            configKey: "transitionMinutes"
        }

        TransitionSlider {
            Layout.fillWidth: true
            label: Translation.tr("End late")
            suffix: Translation.tr("min")
            from: 0
            to: 60
            configKey: "transitionEndMinutes"
        }

        TransitionSlider {
            Layout.fillWidth: true
            label: Translation.tr("Transition")
            suffix: Translation.tr("min")
            from: 15
            to: 60
            configKey: "transitionDuration"
        }

        ToggleItem {
            name: Translation.tr("Enable now")
            description: Translation.tr("More comfortable viewing at night")
            iconName: WIcons.nightLightIcon
            checked: Hyprsunset.active
            onCheckedChanged: {
                Hyprsunset.toggle(checked);
            }
        }

        IntensityEntry {
            Layout.fillWidth: true
        }

        SectionText {
            text: Translation.tr("Anti-flashbang (experimental)")
        }

        ToggleItem {
            name: Translation.tr("Enable")
            description: Translation.tr("Balance brightness based on content")
            iconName: "flash-off"
            checked: Config.options.light.antiFlashbang.enable
            onCheckedChanged: {
                Config.options.light.antiFlashbang.enable = checked;
            }
        }
    }

    component TransitionSlider: RowLayout {
        spacing: 10
        property string label
        property string suffix
        property real from
        property real to
        property string configKey

        FluentIcon {
            Layout.leftMargin: 12
            Layout.topMargin: 4
            Layout.bottomMargin: 4
            Layout.alignment: Qt.AlignTop
            icon: configKey === "transitionMinutes" ? "sunrise" : configKey === "transitionEndMinutes" ? "sunset" : "schedule"
            implicitSize: 18
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.rightMargin: 12
            spacing: 4

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                WText {
                    Layout.fillWidth: true
                    text: label
                    font.pixelSize: Looks.font.pixelSize.large
                }
            }
            WSlider {
                Layout.fillWidth: true
                from: from
                to: to
                value: Config.options.light.night[configKey] ?? 30
                onMoved: Config.options.light.night[configKey] = Math.round(value)
                tooltipContent: Math.round(value)
            }
        }
    }

    component IntensityEntry: RowLayout {
        spacing: 10

        FluentIcon {
            id: iconWidget
            Layout.leftMargin: 12
            Layout.topMargin: 4
            Layout.bottomMargin: 4
            Layout.alignment: Qt.AlignTop
            icon: "temperature"
            implicitSize: 18
        }
        ColumnLayout {
            Layout.fillWidth: true
            // Layout.leftMargin: 40
            Layout.rightMargin: 12
            spacing: 4

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                WText {
                    Layout.fillWidth: true
                    text: Translation.tr("Intensity")
                    font.pixelSize: Looks.font.pixelSize.large
                }
                WText {
                    Layout.fillWidth: true
                    text: Translation.tr("Adjust the color temperature")
                    color: Looks.colors.subfg
                }
            }
            WSlider {
                Layout.fillWidth: true
                from: 6500
                to: 1200
                value: Config.options.light.night.colorTemperature
                onMoved: Config.options.light.night.colorTemperature = value
                tooltipContent: Math.round((value - from) / (to - from) * 100)
            }
        }
    }
}
