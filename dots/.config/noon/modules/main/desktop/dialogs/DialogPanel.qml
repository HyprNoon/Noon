import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.common
import qs.common.widgets
import qs.common.utils
import "content"

Scope {
    id: root
    property string currentMode: GlobalStates.main.sysDialogs.mode

    Variants {
        model: [MonitorsInfo.focused]

        StyledPanel {
            id: panel
            visible: currentMode.length > 0 || bg.anchors.bottomMargin < 0

            required property var modelData
            name: "systemDialog"
            shell: "noon"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }

            FocusHandler {
                windows: [panel]
                active: panel.visible
            }
            mask: Region {
                item: bg
            }
            Item {
                anchors.fill: parent

                StyledRect {
                    id: bg
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                        bottomMargin: contentLoader.active ? -1 : -implicitHeight

                        Behavior on bottomMargin {
                            Anim {}
                        }
                    }

                    topRadius: 40
                    enableBorders: true
                    color: Colors.colLayer0
                    implicitWidth: 800
                    implicitHeight: 420

                    StyledRect {
                        id: topHandle
                        z: 1
                        anchors {
                            topMargin: Padding.large
                            top: parent.top
                            horizontalCenter: parent.horizontalCenter
                        }
                        height: 8
                        width: 100
                        color: Colors.colOutlineVariant
                        radius: Rounding.full
                    }

                    RippleButtonWithIcon {
                        anchors {
                            top: parent.top
                            right: parent.right
                            margins: Padding.massive
                        }
                        buttonRadius: 999
                        implicitSize: 36
                        materialIcon: "close"
                        releaseAction: () => {
                            panel.dismiss();
                        }
                    }

                    StyledLoader {
                        id: contentLoader
                        active: root.currentMode.length > 0
                        anchors.fill: parent
                        asynchronous: true
                        source: sanitizeSource("content/", currentItem.comp)
                        onLoaded: if (ready) {
                            if (currentItem.preload in item)
                                item[currentItem.preload] = GlobalStates.main.sysDialogs.pendingData;
                            item.dismiss.connect(() => panel.dismiss());
                        }
                        readonly property var currentItem: contentMap[root.currentMode]
                        readonly property var contentMap: {
                            "dlp": {
                                comp: "DlpContent",
                                preload: "dropUrl"
                            }
                        }
                    }
                }

                StyledRectangularShadow {
                    target: bg
                    intensity: 0.65
                }
                StyledRect {
                    color: Colors.colScrim
                    opacity: bg.anchors.bottomMargin > -2 ? 0.8 : 0
                    anchors.fill: parent
                    z: -2
                }
                MouseArea {
                    z: -1
                    anchors.fill: parent
                    onClicked: panel.dismiss()
                }
            }

            function dismiss() {
                GlobalStates.main.sysDialogs.mode = "";
            }
        }
    }
}
