import QtQuick
import qs.services

BarRevealerIndicator {
    readonly property var weatherData: WeatherService.weatherData
    expanded: true
    icon: weatherData.currentEmoji
    text: weatherData.currentTemp.slice(0, -1)
    popup: WeatherPopup {}
    altAction: () => WeatherService.loadWeather()
    Component.onCompleted: WeatherService.loadWeather()
}
