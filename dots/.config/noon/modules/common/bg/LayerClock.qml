import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Rectangle {
    id: root

    property bool editMode: false
    readonly property string font: opts.font
    readonly property var weatherData: WeatherService.weatherData
    readonly property bool arabicDayMode: states.arabicMode
    readonly property var states: Mem.states.desktop.clock
    readonly property var opts: Mem.options.desktop.clock
    readonly property real fontVOffset: activeFontInfo.offset ?? 1
    readonly property var activeFontInfo: fontPropsMap[font]
    readonly property var fontPropsMap: {
        "Badeen Display": {
            offset: 0.58
        },
        "Ndot 55": {
            offset: 0.8
        },
        "Six Caps": {
            offset: 0.8
        },
        "Alfa Slab One": {
            offset: 0.8
        },
        "Notable": {
            offset: 0.6
        },
        "Monoton": {
            offset: 0.8,
            weight: 100
        },
        "Titan One": {
            offset: 0.8
        },
        "Bebas Neue": {
            offset: 0.8
        },
        "Rubik": {
            offset: 0.8,
            weight: 900
        },
        "UnifrakturCook": {
            offset: 0.8
        }
    }
    z: 1
    x: Screen.width * states.x
    y: Screen.height * states.y
    color: "transparent"
    implicitHeight: clockItem.implicitHeight * 1.25
    implicitWidth: clockItem.implicitWidth * 1.25
    border.color: clockText.color
    border.width: editMode ? 2 : 0
    radius: Rounding.silly

    MouseArea {
        anchors.fill: clockItem
        drag.target: root
        drag.axis: Drag.XAndYAxis
        drag.minimumX: 0
        drag.maximumX: Screen.width - root.width
        drag.minimumY: 0
        drag.maximumY: Screen.height - root.height
        onPositionChanged: {
            Mem.states.desktop.clock.x = root.x / Screen.width;
            Mem.states.desktop.clock.y = root.y / Screen.height;
        }
        onDoubleClicked: root.editMode = !root.editMode
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: true
    }

    ColumnLayout {
        id: clockItem
        anchors.centerIn: parent
        spacing: 0

        RowLayout {
            Layout.maximumHeight: dateText.contentHeight * fontVOffset
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: Padding.massive * opts.scale
            opacity: 0.8
            StyledText {
                id: dateText
                text: arabicDayMode ? `${DateTimeService.hour}:${DateTimeService.minute}` : DateTimeService.date
                font.weight: root.activeFontInfo.weight ?? 700
                font.pixelSize: 100 * opts.scale
                font.family: root.font
                color: Colors.colSubtext
            }

            RowLayout {
                Symbol {
                    text: weatherData.currentEmoji
                    font.pixelSize: dateText.font.pixelSize * 0.85
                    color: dateText.color
                    fill: 1
                }

                StyledText {
                    text: weatherData.currentTemp
                    font.pixelSize: dateText.font.pixelSize
                    font.family: dateText.font.family
                    font.weight: root.activeFontInfo.weight ?? 700
                    color: dateText.color
                }
            }
        }

        StyledText {
            id: clockText

            Layout.maximumHeight: contentHeight * fontVOffset
            Layout.alignment: Qt.AlignHCenter
            font.family: root.font
            font.weight: root.activeFontInfo.weight ?? 700
            font.pixelSize: 400 * opts.scale
            color: Colors.colOnBackground
            text: arabicDayMode ? DateTimeService.arabicDayName : `${DateTimeService.hour}:${DateTimeService.minute}`

            Behavior on color {
                CAnim {}
            }
        }
    }
}
