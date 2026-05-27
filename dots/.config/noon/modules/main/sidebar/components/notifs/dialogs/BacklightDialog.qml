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
    color: Colors.colLayer1

    bgAnchors {
        rightMargin: Padding.large
        leftMargin: Padding.large
    }

    contentItem: CLayout {
        anchors.fill: parent
        anchors.margins: Padding.large

        PageHeader {
            title: "Kb Backlight"
            subTitle: "Select keyboard backlight device"
            target: root
        }

        PageSeparator {}

        StyledListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.large
            model: Mem.store.services.backlight.devices
            Component.onCompleted: Mem.store.services.backlight.devices.length === 0 ? BacklightService.refreshDevices() : null
            delegate: StyledDelegateItem {
                title: modelData.name
                subtext: "Current: " + modelData.current + " / Max: " + modelData.max
                materialIcon: "backlight_high"
                releaseAction: () => {
                    Mem.options.services.backlightDevice = modelData.name;
                    root.show = false;
                }
            }
        }
    }
}
