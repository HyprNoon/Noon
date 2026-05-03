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

    readonly property int barWidth: Mem.options.bar.appearance.width
    readonly property int elevation: mode === 0 ? Sizes.barElevation : 0
    readonly property int hideMargin: autoHide && !hovered ? -(barWidth - peekSize) : 0

    name: "bar"
    shell: "noon"

    implicitWidth: barWidth + 100
    exclusiveZone: autoHide ? (hovered && !useBg ? barWidth : peekSize) : barWidth

    anchors {
        left: pos === "left"
        right: pos === "right"
        top: true
        bottom: true
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
            implicitWidth: barWidth
            implicitHeight: Screen.height

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: pos === "left" ? parent.left : undefined
                right: pos === "right" ? parent.right : undefined
                leftMargin: pos === "left" ? hideMargin : 0
                rightMargin: pos === "right" ? hideMargin : 0
            }

            Behavior on anchors.leftMargin {
                enabled: pos === "left"
                Anim {}
            }
            Behavior on anchors.rightMargin {
                enabled: pos === "right"
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
                            anchors.rightMargin: pos === "right" ? elevation : -elevation
                            anchors.leftMargin: pos === "left" ? elevation : -elevation
                            anchors.topMargin: Sizes.hyprland.gapsOut
                            anchors.bottomMargin: Sizes.hyprland.gapsOut
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
                            corner: pos === "right" ? cornerEnum.topRight : cornerEnum.topLeft
                        }
                        AnchorChanges {
                            target: c1
                            anchors.top: bg.top
                            anchors.left: pos === "right" ? undefined : bg.right
                            anchors.right: pos === "right" ? bg.left : undefined
                        }
                        PropertyChanges {
                            target: c1
                            anchors.topMargin: Sizes.frameThickness
                        }
                        PropertyChanges {
                            target: c2
                            visible: true
                            corner: pos === "right" ? cornerEnum.bottomRight : cornerEnum.bottomLeft
                        }
                        AnchorChanges {
                            target: c2
                            anchors.bottom: bg.bottom
                            anchors.left: pos === "right" ? undefined : bg.right
                            anchors.right: pos === "right" ? bg.left : undefined
                        }
                        PropertyChanges {
                            target: c2
                            anchors.bottomMargin: Sizes.frameThickness
                        }
                    }
                ]

                transitions: Transition {
                    Anim {
                        properties: "radius,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius,anchors.rightMargin,anchors.leftMargin,anchors.topMargin,anchors.bottomMargin,anchors.margins"
                    }
                }

                VContent {
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
