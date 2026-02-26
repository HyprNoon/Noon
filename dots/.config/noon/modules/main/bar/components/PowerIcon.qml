import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

MaterialShapeWrappedMaterialSymbol {
    // visible: BatteryService.available
    fill: 1
    readonly property var aMap: [
        {
            name: "Power Saver",
            icon: "eco",
            color: Colors.colTertiary,
            sColor: Colors.colOnTertiary,
            shape: MaterialShape.Cookie4Sided
        },
        {
            name: "Balanced",
            icon: "balance",
            color: Colors.colSecondary,
            sColor: Colors.colOnSecondary,
            shape: MaterialShape.Cookie6Sided
        },
        {
            name: "Performance",
            icon: "bolt",
            color: Colors.colPrimary,
            sColor: Colors.colOnPrimary,
            shape: MaterialShape.Cookie9Sided
        }
    ]

    readonly property var currentModeData: aMap.filter(mode => mode.name === PowerService.modeName)[0]

    implicitSize: 32
    text: currentModeData.icon
    shape: currentModeData.shape
    color: currentModeData.color
    colSymbol: currentModeData.sColor

    MouseArea {
        id: mouse

        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: event => event.button === Qt.RightButton ? PowerService.cycleMode(true) : PowerService.cycleMode(false)
    }
}
