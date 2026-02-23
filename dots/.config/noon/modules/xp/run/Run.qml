import "../common"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import qs.services
import qs.common
import QtQuick.Effects
import qs.common.widgets

AppWindow {
    id: root
    title: "run"
    visible: GlobalStates.xp.showRun
    maximumSize: XSizes.run.sizeMax
    minimumSize: XSizes.run.size
    Component.onCompleted: {
        inputField.focus = true;
    }
    StyledRect {
        anchors.centerIn: parent
        implicitHeight: XSizes.run.size.height
        implicitWidth: XSizes.run.size.width
        color: "#EDEAD9"
        ColumnLayout {
            anchors.fill: parent
            spacing: XPadding.large
            anchors {
                topMargin: XPadding.verylarge
                margins: XPadding.large
            }
            RowLayout {
                id: topArea
                spacing: XPadding.small
                StyledImage {
                    Layout.topMargin: 6
                    source: Directories.assets + "/icons/run.png"
                    implicitSize: 46
                }
                ColumnLayout {
                    spacing: 0
                    XText {
                        text: "Type the name of a program, folder, document, or"
                        color: "#0F0C0C"
                        font {
                            pixelSize: XFonts.sizes.verysmall
                            weight: Font.Light
                        }
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignLeft
                    }
                    XText {
                        text: "Internet resource, and Noon will open it for you."
                        color: "#0F0C0C"
                        font {
                            pixelSize: XFonts.sizes.verysmall
                            weight: Font.Light
                        }
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignLeft
                    }
                }
            }
            RowLayout {
                id: centerArea
                Layout.fillWidth: true

                spacing: XPadding.small
                XText {
                    text: "Open: "
                    color: "#0F0C0C"
                    font {
                        pixelSize: XFonts.sizes.verysmall
                        weight: Font.Light
                    }
                }
                TextArea {
                    id: inputField
                    Layout.fillWidth: true
                    implicitHeight: 30
                    renderType: Text.NativeRendering
                    color: "#0F0C0C"
                    selectedTextColor: XColors.colors.colOnPrimary
                    selectionColor: XColors.colors.colPrimary
                    placeholderText: ""
                    background: StyledRect {
                        radius: 0
                        color: "#FEFEFC"
                        border {
                            color: "#A2A5AA"
                            width: 1
                        }
                    }
                    font {
                        family: XFonts.family.main
                        pixelSize: XFonts.sizes.small + 1
                    }
                    Rectangle {
                        anchors {
                            top: parent.top
                            right: parent.right
                            bottom: parent.bottom
                            margins: 2
                        }
                        implicitWidth: 28
                        color: "#B2CBF1"
                        Text {
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: 2
                            font {
                                family: XFonts.family.monospace
                                pixelSize: 24
                            }
                            text: "󰅀"
                        }
                    }
                }
            }
            RowLayout {
                id: bottomArea
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.bottomMargin: -XPadding.small
                Spacer {}
                RowLayout {
                    BottomRunButton {
                        text: "Ok"
                    }
                    BottomRunButton {
                        text: "Cancel"
                        downAction: () => {
                            GlobalStates.xp.showRun = false;
                        }
                    }
                    BottomRunButton {
                        text: "Browse"
                    }
                }
            }
        }
    }
    component BottomRunButton: Rectangle {
        property var downAction
        property alias text: text.text
        border.color: "#364B56"
        border.width: 1
        Layout.preferredHeight: 28
        Layout.preferredWidth: 80
        radius: 4
        MouseArea {
            id: eventArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (downAction) {
                    downAction();
                }
            }
        }
        XText {
            id: text
            font.pixelSize: 13
            color: "#484547"
            anchors.centerIn: parent
        }
    }
}
