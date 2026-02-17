import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    expanded: false
    StyledText {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignCenter
        color: Colors.m3.m3onSurfaceVariant
        text: WeatherService.weatherData.currentTemp
        font.pixelSize: Fonts.sizes.subTitle
        font.family: Fonts.family.numbers
        font.variableAxes: Fonts.variableAxes.longNumbers
    }
}
