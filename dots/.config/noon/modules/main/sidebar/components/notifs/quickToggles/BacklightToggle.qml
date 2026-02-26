import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.functions
import qs.common.utils
import qs.common.widgets
import qs.services

QuickToggleButton {
    id: root
    dialogName: "Backlight"
    buttonIcon: BacklightService.getMaterialIcon()
    toggled: BacklightService.currentLevel > 0
    onClicked: BacklightService.cycle()
}
