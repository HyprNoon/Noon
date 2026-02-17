import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    expanded: true
    StyledText {
        anchors.centerIn: parent
        text: DateTimeService.time.toUpperCase()
        font {
            family: Fonts.family.numbers
            pixelSize: Fonts.sizes.title * 0.85
            variableAxes: Fonts.variableAxes.longNumbers
        }
        color: Colors.colOnSurfaceVariant
    }
}
