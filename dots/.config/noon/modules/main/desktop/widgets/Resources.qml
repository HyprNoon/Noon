import Noon.Services
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    property var resourcesModel: [
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
        rowSpacing: Padding.large
        columnSpacing: Padding.large
        anchors.centerIn: parent
        Repeater {
            model: resourcesModel
            delegate: ColumnLayout {
                spacing: Padding.normal
                Item {
                    Layout.topMargin: 5
                    implicitHeight: 56
                    implicitWidth: 56
                    ClippedFilledCircularProgress {
                        anchors.centerIn: parent
                        value: modelData.percentage
                        implicitSize: 56
                    }
                    Symbol {
                        anchors.centerIn: parent
                        fill: 1
                        text: modelData.iconName
                        font.pixelSize: 38
                        color: Colors.colOnPrimary
                    }
                }
                StyledText {
                    visible: expanded
                    text: 100 * modelData.percentage.toFixed(1) + (modelData.iconName === "thermometer" ? "°C" : "%")
                    color: Colors.colSubtext
                    font.pixelSize: Fonts.sizes.verylarge
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
