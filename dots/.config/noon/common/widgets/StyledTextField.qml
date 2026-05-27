import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets

TextField {
    id: folderPathField

    property QtObject colors: Colors
    property alias radius: rect.radius
    property alias bg: rect
    placeholderTextColor: colors.colOnLayer1
    color: colors.colOnLayer1
    Keys.onEscapePressed: focus = false
    objectName: "searchInput"
    placeholderText: "Search..."
    selectionColor: colors.colSecondaryContainer
    selectedTextColor: colors.colOnSecondaryContainer
    selectByMouse: true

    font {
        family: Fonts.family.main
        pixelSize: Fonts.sizes.small
    }

    background: StyledRect {
        id: rect

        color: colors.colLayer2
        radius: Rounding.large
    }
}
