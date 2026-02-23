import "../common"
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.modules.main.sidebar.components.settings

AppWindow {
    id: root

    /*
        - [ ] titleBar
        - [ ] Controls Row
        - [ ] Explorer Style Navigation

    */

    function dismiss() {
        root.visible = false;
    }

    function minimize() {
        root.visible = false;
    }

    visible: GlobalStates.xp.showControlPanel
    title: "control_panel"
    maximumSize: Qt.size(1600, 900)
    minimumSize: Qt.size(1280, 720)
    Component.onCompleted: {
        searchInput.focus = true;
    }
    StyledRect {
        id: bg

        z: 9
        color: Colors.colLayer0

        anchors {
            fill: parent
        }

        RowLayout {
            id: windowControls

            spacing: Padding.normal

            anchors {
                right: parent.right
                top: parent.top
                topMargin: Padding.verylarge
                rightMargin: Padding.massive
            }

            ControlButton {
                materialIcon: "minimize"
                releaseAction: () => {
                    root.minimize();
                }
            }

            ControlButton {
                materialIcon: "close"
                releaseAction: () => {
                    root.dismiss();
                }
            }
        }

        StyledRect {
            id: searchArea

            z: 99
            focus: true
            implicitHeight: 46
            implicitWidth: 280
            radius: Rounding.huge
            color: Colors.colLayer1
            enableBorders: true

            StyledTextField {
                id: searchInput

                anchors.fill: parent
                font.pixelSize: Fonts.sizes.normal
            }

            anchors {
                top: parent.top
                topMargin: Padding.verylarge
                horizontalCenter: parent.horizontalCenter
            }

            Anim on anchors.topMargin {
                target: searchArea
                duration: 600
                from: -searchArea.height * 1.5
                to: Padding.verylarge
                running: true
            }
        }

        QuickSettings {
            searchQuery: searchInput.text
            anchors.fill: parent
            anchors.margins: Padding.verylarge
        }
    }

    component ControlButton: RippleButtonWithIcon {
        z: 999
        implicitSize: 42
        buttonRadius: Rounding.full
        colBackground: Colors.m3.m3surfaceContainer
    }
}
