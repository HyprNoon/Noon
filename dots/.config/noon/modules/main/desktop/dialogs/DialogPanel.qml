import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import "content"

Scope {
    id: root
    property string currentMode: Globals.main.sysDialogs.mode
    property bool canDismiss: Globals.main.sysDialogs?.pendingData?.canDismiss ?? true
    Variants {
        model: MonitorsInfo.main

        StyledPanel {
            id: panel
            required property var modelData
            screen: modelData
            exclusiveZone: -1
            name: "dialog_panel"
            shell: "noon"
            _layer: "Overlay"
            fill: true
            keyboardFocus: true

            FocusHandler {
                windows: [panel]
                active: panel.visible && (bg.contentMap[root.currentMode]?.focus ?? false)
                onCleared: {
                    if (bg.contentMap[root.currentMode]?.focus)
                        dismiss();
                }
            }

            mask: Region {
                item: root.currentMode !== "" ? mainContainer : bg
            }

            Item {
                id: mainContainer
                anchors.fill: parent

                ShaderRect {
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

                    implicitWidth: Math.min(Screen.width, currentSize.width)
                    implicitHeight: Math.min(Screen.height, currentSize.height)

                    property bool fullScreen: false
                    readonly property size currentSize: fullScreen ? Qt.size(Screen.width, Screen.height) : contentMap[root.currentMode]?.size ?? Qt.size(500, 120)
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
                        "incubate": {
                            comp: "IncubatorContent",
                            focus: true,
                            size: Qt.size(Screen.width * 0.8, Screen.height * 0.7)
                        },
                        "cheats": {
                            comp: "CheatsContent",
                            size: Qt.size(Screen.width * 0.9, Screen.height * 0.8)
                        },
                        "assure": {
                            comp: "AssureContent",
                            preload: "content",
                            size: Qt.size(700, 220)
                        },
                        "ble": {
                            comp: "BLEContent",
                            preload: "content",
                            size: Qt.size(700, 220)
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
                        color: bg.fullScreen ? Colors.colPrimary : Colors.colOutlineVariant
                        radius: Rounding.full

                        MouseArea {
                            anchors.fill: parent
                            onDoubleClicked: bg.fullScreen = !bg.fullScreen
                        }
                    }

                    RippleButtonWithIcon {
                        anchors {
                            top: parent.top
                            right: parent.right
                            margins: Padding.massive
                        }
                        buttonRadius: Rounding.full
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
                        source: currentItem?.comp ? sanitizeSource("content/", currentItem.comp) : ""
                        onLoaded: {
                            if (currentItem.preload in _item)
                                _item[currentItem?.preload] = Globals.main.sysDialogs?.pendingData ?? null;
                            _item.dismiss.connect(() => panel.dismiss());
                            if ("fullScreen" in _item)
                                bg.fullScreen = Qt.binding(() => _item?.fullScreen ?? false);
                        }
                        readonly property var currentItem: bg.contentMap[root?.currentMode]
                    }
                }

                StyledRectangularShadow {
                    target: bg
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
                if (canDismiss)
                    Globals.main.sysDialogs.mode = "";
            }
        }
    }
}
