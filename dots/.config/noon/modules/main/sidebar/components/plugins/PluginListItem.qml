import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.store
import qs.services

StyledRect {
    id: root
    property string icon
    property string shape
    property string name
    property string group
    property string subtext
    property bool enabled
    color: Colors.m3.m3surface
    height: 72

    MouseArea {
        anchors.fill: parent
        onClicked: stateSwitch.clicked()
    }

    MaterialShapeWrappedSymbol {
        id: shape
        anchors.left: parent.left
        anchors.leftMargin: Padding.verylarge
        anchors.verticalCenter: parent.verticalCenter
        text: root.icon
        iconSize: 18
        padding: 12
        shape: MaterialShape.Shape[root.shape]
    }

    RLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: shape.right
        anchors.leftMargin: Padding.huge
        spacing: Padding.large

        CLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 0
            StyledText {
                text: root.name
                color: Colors.colOnLayer3
                font.pixelSize: Fonts.sizes.normal
            }

            StyledText {
                visible: text.length > 0
                text: root.subtext
                color: Colors.colSubtext
                font.pixelSize: Fonts.sizes.small
            }
        }

        Spacer {}

        StyledSwitch {
            id: stateSwitch
            scale: 0.85
            checked: root.enabled
            onClicked: root.enabled ? PluginsManager.disable(root.group, root.name) : PluginsManager.enable(root.group, root.name)
        }

        GroupButtonWithIcon {
            buttonRadius: Rounding.verysmall
            implicitSize: 32
            colBackground: Colors.colError
            colSymbol: Colors.colOnError
            materialIcon: "delete"
            Layout.rightMargin: Padding.veryhuge
            releaseAction: () => PluginsManager.remove(root.group, root.name)
        }
    }
}
