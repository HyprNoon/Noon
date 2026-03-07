import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

GridView {
    id: root

    property bool verticalMode: false
    property var weatherData: WeatherService.weatherData

    Component.onCompleted: WeatherService.loadWeather()
    Layout.fillHeight: true
    Layout.fillWidth: !verticalMode
    cellWidth: verticalMode ? implicitWidth : 100
    cellHeight: verticalMode ? 60 : 35
    flow: verticalMode ? GridView.FlowTopToBottom : GridView.FlowLeftToRight
    model: 1

    delegate: Item {
        width: root.cellWidth
        height: root.cellHeight

        RowLayout {
            anchors.centerIn: parent
            spacing: verticalMode ? 4 : 8

            Symbol {
                text: weatherData.currentEmoji
                iconSize: verticalMode ? Fonts.sizes.large : Fonts.sizes.normal
                color: Colors.colOnLayer1
                fill: 1
            }

            StyledText {
                text: weatherData.currentTemp
                font.pixelSize: Fonts.sizes.normal
                font.family: Fonts.family.main
                color: Colors.colOnLayer1
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            StyledToolTip {
                extraVisibleCondition: parent.containsMouse
                content: weatherData.currentCondition
            }
        }
    }
}
