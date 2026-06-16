import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets

RowLayout {
    id: titleBar
    Layout.fillWidth: true
    Layout.preferredHeight: 72
    Layout.margins: Padding.massive
    spacing: Padding.massive * 2
    required property QtObject states
    property string pageTitle: "Home"
    property string pageSubtitle: "Subtitle"
    property string pageIcon: "home"

    GroupButtonWithIcon {
        materialIcon: "menu"
        implicitSize: 48
        Layout.fillHeight: false
        Layout.fillWidth: false
        colBackground: Colors.colSurfaceContainerHigh
        colBackgroundHover: Colors.colSurfaceContainerHighestHover
        colBackgroundActive: Colors.colSurfaceContainerHighestActive
        releaseAction: () => titleBar.states.sidebarOpen = true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Padding.large

        Symbol {
            fill: 1
            text: titleBar.pageIcon
            iconSize: 54
            color: Colors.colOnSurface
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                text: titleBar.pageTitle
                Layout.fillWidth: true
                font.pixelSize: Fonts.sizes.title
                font.family: Fonts.family.variable
                font.variableAxes: Fonts.variableAxes.title
                color: Colors.colOnSurface
            }

            StyledText {
                text: titleBar.pageSubtitle
                leftPadding: Padding.small
                Layout.fillWidth: true
                font.pixelSize: Fonts.sizes.normal
                font.family: Fonts.family.variable
                font.variableAxes: Fonts.variableAxes.main
                color: Colors.colOnSurfaceVariant
            }
        }
    }

    GroupButtonWithIcon {
        materialIcon: "close"
        implicitSize: 48
        Layout.fillHeight: false
        Layout.fillWidth: false
        colBackground: Colors.colSurfaceContainerHigh
        colBackgroundHover: Colors.colSurfaceContainerHighestHover
        colBackgroundActive: Colors.colSurfaceContainerHighestActive
        releaseAction: () => Globals.common.openGameUI = false
    }
}
