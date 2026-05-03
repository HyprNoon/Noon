import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.modules.main.bar.components

StyledPanel {
    id: bar

    property bool hovered: false

    readonly property string pos: Mem.options.bar.behavior.position
    readonly property bool autoHide: Mem.options.bar.behavior.autoHide
    readonly property int mode: Mem.options.bar.appearance.mode
    readonly property bool useBg: Mem.options.bar.appearance.useBg
    readonly property int peekSize: 10

    readonly property int barHeight: Mem.options.bar.appearance.height
    readonly property int elevation: mode === 0 ? Sizes.barElevation : 0
    readonly property int hideMargin: autoHide && !hovered ? -(barHeight - peekSize) : 0

    name: "bar"
    shell: "noon"

    implicitHeight: barHeight + 100
    exclusiveZone: autoHide ? (hovered && !useBg ? barHeight : peekSize) : barHeight

    anchors {
        left: true
        right: true
        top: pos === "top"
        bottom: pos === "bottom"
    }

    mask: Region {
        item: bg
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: autoHide
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true

        onEntered: if (autoHide)
            bar.hovered = true
        onExited: if (autoHide)
            bar.hovered = false

        Item {
            id: container

            opacity: autoHide && !hovered ? 0 : 1
            implicitHeight: barHeight
            implicitWidth: Screen.width

            anchors {
                left: parent.left
                right: parent.right
                top: pos === "top" ? parent.top : undefined
                bottom: pos === "bottom" ? parent.bottom : undefined
                topMargin: pos === "top" ? hideMargin : 0
                bottomMargin: pos === "bottom" ? hideMargin : 0
            }

            Behavior on anchors.topMargin {
                enabled: pos === "top"
                Anim {}
            }
            Behavior on anchors.bottomMargin {
                enabled: pos === "bottom"
                Anim {}
            }

            StyledRectangularShadow {
                target: bg
            }

            ShaderRect {
                id: bg

                anchors.fill: parent
                enableBorders: false
                extraShaderCondition: useBg

                states: [
                    State {
                        name: "floating"
                        when: mode === 0
                        PropertyChanges {
                            target: bg
                            anchors.topMargin: pos === "top" ? elevation : -elevation
                            anchors.bottomMargin: pos === "bottom" ? elevation : -elevation
                            anchors.leftMargin: Sizes.hyprland.gapsOut
                            anchors.rightMargin: Sizes.hyprland.gapsOut
                            radius: Rounding.verylarge
                            enableBorders: Mem.options.bar.appearance.outline
                        }
                        PropertyChanges {
                            target: c1
                            visible: false
                        }
                        PropertyChanges {
                            target: c2
                            visible: false
                        }
                    },
                    State {
                        name: "docked"
                        when: mode === 1
                        PropertyChanges {
                            target: bg
                            anchors.margins: 0
                            radius: 0
                            enableBorders: false
                        }
                        PropertyChanges {
                            target: c1
                            visible: false
                        }
                        PropertyChanges {
                            target: c2
                            visible: false
                        }
                    },
                    State {
                        name: "dockedCornered"
                        when: mode === 2
                        PropertyChanges {
                            target: bg
                            anchors.margins: 0
                            radius: 0
                            enableBorders: false
                        }
                        PropertyChanges {
                            target: c1
                            visible: true
                            corner: pos === "bottom" ? cornerEnum.bottomLeft : cornerEnum.topLeft
                            anchors.leftMargin: Sizes.frameThickness
                        }
                        AnchorChanges {
                            target: c1
                            anchors.left: bg.left
                            anchors.top: pos === "bottom" ? undefined : bg.bottom
                            anchors.bottom: pos === "bottom" ? bg.top : undefined
                        }
                        PropertyChanges {
                            target: c2
                            visible: true
                            corner: pos === "bottom" ? cornerEnum.bottomRight : cornerEnum.topRight
                            anchors.rightMargin: Sizes.frameThickness
                        }
                        AnchorChanges {
                            target: c2
                            anchors.right: bg.right
                            anchors.top: pos === "bottom" ? undefined : bg.bottom
                            anchors.bottom: pos === "bottom" ? bg.top : undefined
                        }
                    }
                ]

                transitions: Transition {
                    Anim {
                        properties: "radius,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius,anchors.topMargin,anchors.bottomMargin,anchors.leftMargin,anchors.rightMargin,anchors.margins"
                    }
                }

                Content {
                    barRoot: bar
                }

                RoundCorner {
                    id: c1
                    visible: false
                }

                RoundCorner {
                    id: c2
                    visible: false
                }
            }
        }
    }
}
