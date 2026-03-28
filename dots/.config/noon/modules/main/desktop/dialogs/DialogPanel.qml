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
        model: Quickshell.screens

        StyledPanel {
            id: panel
            visible: currentMode.length > 0 || bg.anchors.bottomMargin < 0

            required property var modelData
            screen: modelData
            exclusiveZone: -1
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
                item: root.currentMode !== "" ? mainContainer : bg
            }

            Item {
                id: mainContainer
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
                    implicitWidth: Math.min(Screen.width, currentSize.width)
                    implicitHeight: Math.min(Screen.height, currentSize.height)

                    readonly property size currentSize: contentMap[root.currentMode]?.size ?? Qt.size(500, 120)
                    readonly property var contentMap: {
                        "dlp": {
                            comp: "DlpContent",
                            preload: "url",
                            size: Qt.size(800, 420)
                        },
                        "thawb": {
                            comp: "ThawbContent",
                            preload: "url",
                            size: Qt.size(600, 220)
                        },
                        "assure": {
                            comp: "AssureContent",
                            preload: "content",
                            size: Qt.size(1800, 220)
                        }
                    }
                    StyledText {
                        visible: root.currentMode === ""
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: Padding.massive * 2
                        text: "..."
                        color: Colors.colSubtext
                        font.pixelSize: Fonts.sizes.subTitle
                        font.variableAxes: Fonts.variableAxes.title
                    }
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
                        source: sanitizeSource("content/", currentItem?.comp) ?? null
                        onLoaded: if (ready) {
                            if (currentItem.preload in item)
                                item[currentItem.preload] = GlobalStates.main.sysDialogs.pendingData;
                            item.dismiss.connect(() => panel.dismiss());
                        }
                        readonly property var currentItem: bg.contentMap[root.currentMode]
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
                    MouseArea {
                        anchors.fill: parent
                        onClicked: panel.dismiss()
                    }
                }
            }

            function dismiss() {
                GlobalStates.main.sysDialogs.mode = "";
            }
        }
    }
}
