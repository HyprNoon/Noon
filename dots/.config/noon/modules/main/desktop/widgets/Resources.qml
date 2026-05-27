import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

WidgetContainer {
    id: root
    readonly property int implicitCircSize: 72
    readonly property var resourcesModel: [
        {
            iconName: "memory",
            percentage: (ResourcesService.stats.mem_total - ResourcesService.stats.mem_available) / ResourcesService.stats.mem_total
        },
        {
            iconName: "swap_horiz",
            percentage: (ResourcesService.stats.swap_total - ResourcesService.stats.swap_free) / ResourcesService.stats.swap_total
        },
        {
            iconName: "settings_slow_motion",
            percentage: ResourcesService.stats.cpu_percent / 100
        },
        {
            iconName: "thermometer",
            percentage: ResourcesService.stats.cpu_temp / 100
        }
    ]
    GridLayout {
        columns: expanded ? 4 : 2
        rows: expanded ? 2 : 1
        rowSpacing: expanded ? Padding.huge : Padding.normal
        columnSpacing: expanded ? Padding.huge : Padding.normal
        anchors.centerIn: parent
        Repeater {
            model: ScriptModel {
                values: resourcesModel
            }
            delegate: ColumnLayout {
                spacing: Padding.small
                Item {
                    Layout.topMargin: expanded ? Padding.huge : 0
                    implicitHeight: root.implicitCircSize
                    implicitWidth: root.implicitCircSize
                    ClippedFilledCircularProgress {
                        anchors.centerIn: parent
                        value: modelData.percentage
                        implicitSize: root.implicitCircSize
                    }
                    Symbol {
                        anchors.centerIn: parent
                        fill: 1
                        text: modelData.iconName
                        font.pixelSize: root.implicitCircSize * 0.6
                        color: Colors.colOnPrimary
                    }
                }
                StyledText {
                    visible: expanded
                    text: 100 * modelData.percentage.toFixed(1) + (modelData.iconName === "thermometer" ? "°C" : "%")
                    color: Colors.colOnSurface
                    font.family: Fonts.family.variable
                    font.variableAxes: Fonts.variableAxes.longNumbers
                    font.pixelSize: Fonts.sizes.huge
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
