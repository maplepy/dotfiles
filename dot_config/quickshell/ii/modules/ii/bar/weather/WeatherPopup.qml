import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.ii.bar
import qs.services

StyledPopup {
    id: root

    ColumnLayout {
        id: columnLayout

        anchors.centerIn: parent
        implicitWidth: Math.max(header.implicitWidth, gridLayout.implicitWidth)
        implicitHeight: gridLayout.implicitHeight
        spacing: 5

        // Header
        ColumnLayout {
            id: header

            Layout.alignment: Qt.AlignHCenter
            spacing: 2

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 6

                MaterialSymbol {
                    fill: 0
                    font.weight: Font.Medium
                    text: "location_on"
                    iconSize: Appearance.font.pixelSize.large
                    color: Appearance.colors.colOnSurfaceVariant
                }

                StyledText {
                    text: Weather.data.city
                    color: Appearance.colors.colOnSurfaceVariant

                    font {
                        weight: Font.Medium
                        pixelSize: Appearance.font.pixelSize.normal
                    }

                }

            }

            StyledText {
                id: temp

                font.pixelSize: Appearance.font.pixelSize.smaller
                color: {
                    let t = parseInt(Weather.data.temp);
                    if (t > 25)
                        return Appearance.m3colors.m3error;
                    else if (t < 10)
                        return Appearance.m3colors.m3primary;
                    return Appearance.colors.colOnSurfaceVariant;
                }
                text: Weather.data.temp + " • " + ("Feels like %1").arg(Weather.data.tempFeelsLike)
            }

        }

        // Metrics grid
        GridLayout {
            id: gridLayout

            columns: 2
            rowSpacing: 5
            columnSpacing: 5
            uniformCellWidths: true

            WeatherCard {
                title: ("High")
                symbol: "keyboard_arrow_up"
                value: `${Weather.data.highTemp} • ${Weather.data.highTime}`
                accentColor: parseInt(Weather.data.highTemp) >= 25 ? "tertiary" : "default"
            }

            WeatherCard {
                title: ("Low")
                symbol: "keyboard_arrow_down"
                value: `${Weather.data.lowTemp} • ${Weather.data.lowTime}`
                accentColor: parseInt(Weather.data.lowTemp) <= 10 ? "primary" : "default"
            }

            WeatherCard {
                title: ("UV Index")
                symbol: "wb_sunny"
                value: Weather.data.uv
                accentColor: parseInt(Weather.data.uv) > 6 ? "tertiary" : "default"
            }

            WeatherCard {
                title: ("Wind")
                symbol: "air"
                value: `(${Weather.data.windDir}) ${Weather.data.wind}`
                accentColor: "default"
            }

            WeatherCard {
                title: ("Precipitation")
                symbol: "rainy_light"
                value: Weather.data.precip
                accentColor: parseFloat(Weather.data.precip) > 0 ? "primary" : "default"
            }

            WeatherCard {
                title: ("Humidity")
                symbol: "humidity_low"
                value: Weather.data.humidity
                accentColor: parseInt(Weather.data.humidity) > 70 ? "success" : "default"
            }

            WeatherCard {
                title: ("Visibility")
                symbol: "visibility"
                value: Weather.data.visib
                accentColor: "default"
            }

            WeatherCard {
                title: ("Pressure")
                symbol: "readiness_score"
                value: Weather.data.press
                accentColor: "default"
            }

            WeatherCard {
                title: ("Sunrise")
                symbol: "wb_twilight"
                value: Weather.data.sunrise
                accentColor: "default"
            }

            WeatherCard {
                title: ("Sunset")
                symbol: "bedtime"
                value: Weather.data.sunset
                accentColor: "default"
            }

        }

        // Footer: last refresh
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: ("Last refresh: %1").arg(Weather.data.lastRefresh)
            color: Appearance.colors.colOnSurfaceVariant

            font {
                weight: Font.Medium
                pixelSize: Appearance.font.pixelSize.smaller
            }

        }

    }

}
