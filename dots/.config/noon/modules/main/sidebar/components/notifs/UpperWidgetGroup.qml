import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store
import "quickToggles"
import "sliders"

Item {
    id: root

    property var panelWindow

    implicitHeight: contentLayout.implicitHeight + Padding.large
    Layout.fillWidth: true

    ColumnLayout {
        id: contentLayout

        spacing: Padding.normal

        anchors {
            fill: parent
            bottomMargin: Padding.large
            topMargin: Padding.normal
        }

        DateUptime {}

        Group {
            visible: Mem.options.sidebar.appearance.showSliders ?? false
            Layout.preferredHeight: sliders.implicitHeight + sliders.anchors.margins
            ColumnLayout {
                id: sliders
                anchors.margins: Padding.huge
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: Padding.verysmall
                Layout.rightMargin: Padding.normal

                BrightnessSlider {}
                VolumeOutputSlider {}
                VolumeInputSlider {}
            }
        }
        Group {
            id: mainGroup
            Layout.preferredHeight: grid.implicitHeight + Padding.massive * 1.5
            Layout.fillWidth: true
            radius: Rounding.massive
            ColumnLayout {
                id: grid
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: Padding.huge
                spacing: Padding.normal
                Repeater {
                    model: [
                        {
                            items: ["NetworkToggle", "BluetoothToggle"]
                        },
                        {
                            items: ["NightLightToggle", "AppearanceToggle"]
                        },
                        {
                            items: ["PhoneToggle", "TransparencyToggle"]
                        }
                    ]
                    delegate: ButtonGroup {
                        required property var modelData
                        required property int index
                        Layout.fillWidth: true
                        spacing: Padding.normal

                        Repeater {
                            model: modelData.items
                            delegate: StyledLoader {
                                required property var modelData
                                Layout.fillWidth: true
                                source: sanitizeSource("quickToggles/", modelData)
                                onLoaded: _item.showButtonName = true
                            }
                        }
                    }
                }
            }
        }
        ListView {
            Layout.alignment: Qt.AlignHCenter
            spacing: Padding.small
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            clip: true
            snapMode: ListView.SnapOneItem
            orientation: Qt.Horizontal
            model: ["CaffieneToggle", "EasyEffectsToggle", "RecordToggle", "GameModeToggle", "InputToggle", "BacklightToggle"]
            delegate: StyledLoader {
                anchors.verticalCenter: parent?.verticalCenter
                required property var modelData
                source: sanitizeSource("quickToggles/", modelData)
                onLoaded: _item.showButtonName = false
            }
        }
    }

    component DateUptime: ColumnLayout {
        Layout.preferredHeight: 45
        spacing: 0
        Layout.alignment: Qt.AlignTop
        StyledText {
            font.pixelSize: Fonts.sizes.verylarge
            color: Colors.colOnLayer0
            text: DateTimeService.date
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Padding.large
        }
        StyledText {
            font.pixelSize: Fonts.sizes.normal
            color: Colors.colSubtext
            text: "Up for " + DateTimeService.uptime
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: Padding.large
        }
    }
    component Group: StyledRect {
        Layout.fillWidth: true
        radius: Rounding.verylarge
        color: Colors.colLayer1
    }
}
