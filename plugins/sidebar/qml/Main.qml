import QtQuick
import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services

StyledRect {
    StyledText {
        anchors.centerIn: parent
        text: "Hello World"
        font.pixelSize: Fonts.sizes.title
        color: Colors.colOnPrimaryContainer
    }
}
