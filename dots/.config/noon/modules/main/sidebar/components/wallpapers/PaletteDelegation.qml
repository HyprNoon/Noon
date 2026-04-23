import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

GroupButton {
    id: root
    required property var modelData
    readonly property var currentData: modelData[Mem.states.desktop.appearance.mode]

    baseWidth: 65
    baseHeight: 65
    releaseAction: () => WallpaperService.changeAccentColor(currentData.primary)
    colBackground: Colors.colLayer2
    buttonRadius: Rounding.large
    StyledRect {
        color: currentData.primary
        anchors.centerIn: parent
        implicitSize: 50
        radius: Rounding.full
        clip: true

        Rectangle {
            id: leftRect
            color: currentData.secondary
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: parent.height / 2
            width: height
        }

        Rectangle {
            color: currentData.primaryContainer
            anchors.left: leftRect.right
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            height: parent.height / 2
            width: height
        }
    }
}
