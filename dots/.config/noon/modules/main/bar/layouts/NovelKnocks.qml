import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services
import qs.common.widgets
import qs.modules.main.bar.components

StyledPanel {
    id: root
    readonly property int spacing: Padding.large
    readonly property int chunkWidth: 380
    readonly property int barHeight: 58
    readonly property string pos: Mem.options.bar.behavior.position
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
    Item {
        id: contentItem
        anchors.top: center.top
        anchors.bottom: center.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        height: root.exclusiveZone
    }

    Chunk {
        id: left
        anchors.top: center.top
        anchors.bottom: center.bottom
        anchors.right: center.left
        anchors.rightMargin: root.spacing
        implicitWidth: chunkWidth
        RLayout {
            id: leftRow
            anchors.fill: parent
            anchors.margins: Padding.normal
            Media {
                Layout.fillWidth: true
            }
            Spacer {}
            Resources {}
        }
    }

    Chunk {
        id: center
        anchors.top: pos === "top" ? parent.top : undefined
        anchors.bottom: pos === "bottom" ? parent.bottom : undefined
        anchors.margins: Sizes.elevationMargin
        anchors.horizontalCenter: parent.horizontalCenter
        content: workspaces
        Workspaces {
            id: workspaces
            anchors.centerIn: parent
            bar: root
        }
    }

    Chunk {
        id: right
        anchors.top: center.top
        anchors.bottom: center.bottom
        anchors.left: center.right
        anchors.leftMargin: root.spacing
        implicitWidth: chunkWidth
        RLayout {
            id: rightRow
            anchors.fill: parent
            anchors.leftMargin: Padding.massive
            anchors.margins: Padding.normal
            PowerIcon {}
            StackedClockWidget {}
            Spacer {}
            StatusIcons {}
        }
    }

    component StackedClockWidget: ColumnLayout {
        spacing: 0
        Layout.fillWidth: true
        Layout.topMargin: Padding.tiny
        Layout.leftMargin: Padding.normal
        Layout.preferredHeight: 36
        Layout.alignment: Qt.AlignVCenter
        StyledText {
            color: Colors.colOnLayer0
            text: DateTimeService.time
            font.pixelSize: Fonts.sizes.normal
            font.variableAxes: Fonts.variableAxes.title
        }
        StyledText {
            color: Colors.colSubtext
            text: DateTimeService.date
            opacity: 0.7
        }
    }

    component Chunk: StyledRect {
        property var content
        color: Colors.colLayer0
        radius: Rounding.large
        implicitHeight: 56
        implicitWidth: content.implicitWidth + Padding.massive * 1.5
        enableBorders: true
    }
}
