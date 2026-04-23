import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root

    collapsedHeight: 440
    color: Colors.colLayer1
    bgAnchors {
        rightMargin: Padding.large
        leftMargin: Padding.large
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.verylarge
        spacing: 0

        BottomDialogHeader {
            title: qsTr("Transparency")
        }

        BottomDialogSeparator {}

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.verylarge
            spacing: Padding.verylarge

            OptionsSection {
                icon: "blur_on"
                title: "Transparency"
                checked: Mem.options.appearance.transparency.enabled
                action: Mem.options.appearance.transparency.enabled = checked
            }
            OptionsSection {
                icon: "rocket_launch"
                title: "Blur Applications"
                checked: !Mem.options.desktop.hyprland.unBlurApps
                action: Mem.options.desktop.hyprland.unBlurApps = !checked
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Padding.small

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Padding.small

                    Symbol {
                        text: "tune"
                        font.pixelSize: Fonts.sizes.verylarge
                        color: Colors.colOnSurfaceVariant
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: "Shell Alpha"
                        color: Colors.colOnSurfaceVariant
                    }

                    StyledSlider {
                        Layout.minimumWidth: 80
                        Layout.fillWidth: true
                        from: 0
                        to: Mem.options.desktop.hyprland.layerAlpha - 0.01
                        value: Mem.options.appearance.transparency.scale
                        onMoved: Mem.options.appearance.transparency.scale = value
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Padding.small

                    Symbol {
                        text: "tune"
                        font.pixelSize: Fonts.sizes.verylarge
                        color: Colors.colOnSurfaceVariant
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: "Applications alpha"
                        color: Colors.colOnSurfaceVariant
                    }

                    StyledSlider {
                        Layout.minimumWidth: 80
                        Layout.fillWidth: true
                        from: 0
                        to: 1
                        value: Mem.options.desktop.hyprland.applicationsOpacity
                        onMoved: Mem.options.desktop.hyprland.applicationsOpacity = value
                    }
                }
            }
            Spacer {}
        }

        RowLayout {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
    component OptionsSection: RowLayout {
        property alias icon: symb.text
        property alias checked: button.checked
        property alias title: title.text
        property var action
        Layout.fillWidth: true
        spacing: Padding.small
        Symbol {
            id: symb
            font.pixelSize: Fonts.sizes.verylarge
            color: Colors.colOnSurfaceVariant
        }
        StyledText {
            id: title
            Layout.fillWidth: true
            text: qsTr("Enable Transparency")
            color: Colors.colOnSurfaceVariant
        }

        StyledSwitch {
            id: button
            onToggled: action()
        }
    }
}
