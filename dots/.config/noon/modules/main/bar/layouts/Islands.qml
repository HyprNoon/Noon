import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.modules.main.bar.components
import qs.services

StyledPanel {
    id: root
    readonly property int barHeight: 60
    readonly property string pos: Mem.options.bar.behavior.position
    readonly property int maxChunkWidth: 250

    name: "bar"
    shell: "noon"
    implicitHeight: barHeight + 100
    exclusiveZone: barHeight + Sizes.elevationMargin
    anchors.top: pos === "top"
    anchors.bottom: pos === "bottom"
    anchors.right: true
    anchors.left: true

    mask: Region {
        item: contentItem
    }

    margins {
        left: Padding.large
        right: Padding.large
    }

    Item {
        id: contentItem
        anchors {
            top: pos === "top" ? parent.top : undefined
            bottom: pos === "bottom" ? parent.bottom : undefined
            right: parent.right
            left: parent.left
        }
        height: root.barHeight
        RowLayout {
            spacing: Padding.large
            anchors.fill: parent
            anchors.margins: Sizes.elevationMargin

            PowerIcon {}

            Chunk {
                id: wsChunk

                Workspaces {
                    anchors.centerIn: parent
                    bar: root
                }
            }

            Chunk {
                width: root.maxChunkWidth
                InlineWindowTitle {
                    bar: barRoot
                    anchors.centerIn: parent
                }
            }

            Spacer {}

            Chunk {
                RowLayout {
                    id: indicatorsAreaRow

                    spacing: Padding.small
                    anchors.centerIn: parent
                    height: parent.height

                    SysTray {
                        bar: root
                        visible: model.length > 0
                        Layout.fillWidth: true
                        Layout.minimumWidth: 100
                    }

                    StatusIcons {}
                    MinimalBattery {}
                }
            }
        }

        Chunk {
            id: centerChunk
            anchors.centerIn: parent
            width: clock.implicitWidth + Padding.massive * 2
            StyledText {
                id: clock
                font {
                    family: Fonts.family.title
                    variableAxes: Fonts.variableAxes.title
                    pixelSize: Fonts.sizes.normal
                }
                anchors.centerIn: parent
                color: Colors.colOnLayer0
                text: DateTimeService.time
            }
        }
    }
    component Chunk: StyledRect {
        color: Colors.colLayer0
        radius: Rounding.full
        enableBorders: true
        height: 47
        width: childrenRect.width + Padding.massive
    }
}
