import "./widgets"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root

    implicitWidth: 450
    implicitHeight: parent.height
    color: "transparent"
    clip: true
    topRadius: Rounding.huge

    anchors {
        bottomMargin: -parent.height - 2 * Padding.massive
        bottom: parent.bottom
        left: parent.left
        margins: Padding.massive
    }

    ColumnLayout {
        z: 99

        anchors {
            fill: parent
            margins: Padding.large
            bottomMargin: 2 * Padding.massive
        }

        LockClock {}
        Spacer {}
        Music {}
    }

    Anim on anchors.bottomMargin {
        from: -root.implicitHeight
        to: -Padding.massive
    }
}
