import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

StyledPopup {
    id: root

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        width: parent ? parent.width * 0.9 : 0
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            StyledText {
                text: WeatherService.currentCity
                color: Colors.m3.m3onSurface
                font.pixelSize: Fonts.sizes.large
                font.weight: Font.Bold
            }

            StyledText {
                text: WeatherService.weatherData.currentCondition
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.small
                opacity: 0.7
            }
        }

        RowLayout {
            Layout.fillWidth: true

            StyledText {
                text: "Temperature"
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.normal
                font.weight: Font.Medium
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                text: WeatherService.weatherData.currentTemp
                color: Colors.m3.m3primary
                font.pixelSize: Fonts.sizes.normal
                font.weight: Font.DemiBold
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Colors.m3.m3outlineVariant
            opacity: 0.2
            Layout.topMargin: 4
            Layout.bottomMargin: 4
        }

        Repeater {
            model: [
                {
                    label: "Feels like",
                    value: WeatherService.weatherData.feelsLike
                },
                {
                    label: "Humidity",
                    value: WeatherService.weatherData.humidity
                },
                {
                    label: "Wind",
                    value: WeatherService.weatherData.windSpeed
                },
                {
                    label: "Visibility",
                    value: WeatherService.weatherData.visibility
                }
            ]

            delegate: RowLayout {
                Layout.fillWidth: true
                visible: modelData.value !== ""

                StyledText {
                    text: modelData.label
                    color: Colors.m3.m3onSurfaceVariant
                    font.pixelSize: Fonts.sizes.small
                    opacity: 0.7
                }

                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: modelData.value
                    color: Colors.m3.m3onSurface
                    font.pixelSize: Fonts.sizes.small
                    font.weight: Font.Medium
                }
            }
        }
    }
}
