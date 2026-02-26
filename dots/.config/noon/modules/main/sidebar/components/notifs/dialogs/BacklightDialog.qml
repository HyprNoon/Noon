import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    collapsedHeight: 400
    enableStagedReveal: false
    contentItem:CLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive

        BottomDialogHeader {
            title: "Kb Backlight"
            subTitle: "Select keyboard backlight device"
            target: root
        }

        BottomDialogSeparator {}

        StyledListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: Mem.store.services.backlight.devices
            Component.onCompleted: Mem.store.services.backlight.devices.length === 0 ? BacklightService.refreshDevices() : null
            delegate: StyledDelegateItem {
                title:modelData.name
                subtext: "Current: " + modelData.current + " / Max: " + modelData.max
                materialIcon: "backlight_high"
                releaseAction: ()=> {
                    Mem.options.services.backlightDevice = modelData.name
                    root.show = false
                }
            }
        }
    }
}
