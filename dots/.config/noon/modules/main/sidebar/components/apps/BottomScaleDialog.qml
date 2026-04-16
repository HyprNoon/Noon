import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    collapsedHeight: 220
    enableStagedReveal: false
    bottomAreaReveal: true
    hoverHeight: 300
    color: Colors.colLayer2

    contentItem: ColumnLayout {
        spacing: Padding.small
        anchors.fill: parent
        anchors.margins: Padding.massive

        BottomDialogHeader {
            title: "List Tweaks"
            showCloseButton: false
        }

        StyledText {
            text: "View Scale: " + Math.round(Mem.options.sidebar.appearance.itemListScale * 100) + "%"
            color: Colors.colSubtext
            Layout.fillWidth: true
        }

        RLayout {
            Layout.preferredHeight: 85

            StyledSlider {
                id: scaleSlider
                from: 0.34
                to: 2
                value: Mem.options.sidebar.appearance.itemListScale
                onValueChanged: Mem.options.sidebar.appearance.itemListScale = value
            }
            RippleButtonWithIcon {
                materialIcon: "restart_alt"
                releaseAction: () => {
                    scaleSlider.value = 1;
                }
            }
        }
        RLayout {
            Layout.rightMargin: Padding.small
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            StyledText {
                text: "List Stripes"
                color: Colors.colSubtext
                Layout.fillWidth: true
            }
            StyledSwitch {

                checked: Mem.options.sidebar.appearance.alternateListStripes
                onCheckedChanged: Mem.options.sidebar.appearance.alternateListStripes = checked
            }
        }
    }
}
