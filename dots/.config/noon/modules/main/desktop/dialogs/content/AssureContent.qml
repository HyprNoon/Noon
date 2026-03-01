import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

Item {
    id: root
    anchors.fill: parent
    signal dismiss

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Padding.large
    }
}
