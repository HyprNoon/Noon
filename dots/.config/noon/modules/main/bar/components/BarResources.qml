import Noon.Services
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root
    implicitWidth: 85
    Layout.topMargin: -4
    Layout.fillHeight: true
    spacing: 0
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
    Repeater {
        model: resourcesModel
        delegate: RowLayout {
            Layout.fillWidth: true
            visible: modelData.percentage > 0.01
            Symbol {
                text: modelData.iconName
                color: Colors.colOnLayer0
                fill: 1
                font.pixelSize: 12
            }
            ClippedProgressBar {
                showEndPoint: false
                Layout.fillWidth: true
                Layout.preferredHeight: 6
                value: modelData.percentage
            }
        }
    }
}
