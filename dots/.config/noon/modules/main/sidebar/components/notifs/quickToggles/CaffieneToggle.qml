import QtQuick
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

QuickToggleButton {
    id: root

    dialogName: "Caffaine"
    toggled: IdleService.inhibited
    buttonIcon: "coffee"
    buttonName: toggled ? "Awake" : "Sleepy"
    onClicked: IdleService.toggleInhibit()
}
