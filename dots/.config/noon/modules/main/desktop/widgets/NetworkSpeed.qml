import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    GridLayout {
        columns: expanded ? 4 : 2
        rows: expanded ? 1 : 2
        anchors.centerIn: parent
        Symbol {
            text: "arrow_warm_up"
            color: Colors.m3.m3onSurfaceVariant
            font.pixelSize: Fonts.sizes.subTitle
        }

        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
            color: Colors.m3.m3onSurfaceVariant
            text: NetworkService.uploadSpeedText
            font.pixelSize: Fonts.sizes.large

        }

        Symbol {
            text: "arrow_cool_down"
            color: Colors.m3.m3onSurfaceVariant
            font.pixelSize: Fonts.sizes.subTitle
        }

        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
            color: Colors.m3.m3onSurfaceVariant
            text: NetworkService.downloadSpeedText
            font.pixelSize: Fonts.sizes.large

        }
    }
}
