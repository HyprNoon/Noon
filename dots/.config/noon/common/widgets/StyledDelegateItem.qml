import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.folderlistmodel
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.services
import qs.common.functions
import qs.modules.main.sidebar

RippleButton {
    id: root
    property real mainScale: 1
    property string iconSource
    property QtObject colors: Colors
    property bool active: toggled
    property int shapePadding: 6
    property var shape: MaterialShape.Shape.Cookie6Sided
    property string title: ""
    property string subtext: ""
    property color colSubtext: Colors.colSubtext
    property color colTitle: Colors.colOnLayer2
    property bool expanded: true
    property int extraRightPadding: 0
    property string materialIcon: "music_note"
    property int fill: 0
    readonly property bool isMinimumScale: mainScale < 0.35
    width: parent?.width
    implicitHeight: 64 * mainScale
    colBackgroundToggled: colors.colPrimaryContainer
    colBackgroundHover: colors.colPrimaryContainerHover
    colBackgroundToggledHover: colors.colPrimaryContainerHover
    colBackground: colors.colLayer2
    // buttonRadius: Rounding.large
    Loader {
        id: iconLoader
        active: visible
        visible: !root.isMinimumScale
        z: -1
        sourceComponent: iconSource.length > 0 ? iconComponent : shapeComponent
        anchors {
            left: parent.left
            leftMargin: Padding.huge
            verticalCenter: parent.verticalCenter
        }

        Component {
            id: iconComponent
            CroppedImage {
                clip: true
                asynchronous: true
                anchors.centerIn: parent
                radius: Rounding.large * root.mainScale
                implicitSize: 50 * root.mainScale
                source: root.iconSource
            }
        }
        Component {
            id: shapeComponent
            MaterialShapeWrappedSymbol {
                id: m3shape
                colors: root.colors
                shape: MaterialShape.Cookie6Sided
                padding: Padding.large
                iconSize: root.mainScale * parent.height / 2.5
                colSymbol: root.active ? colors.colPrimaryActive : colors.colPrimary
                text: root.materialIcon
                fill: root.fill
                MouseArea {
                    id: shapeHoverArea
                    enabled: !root.expanded
                    hoverEnabled: true
                    anchors.fill: parent
                }
                StyledToolTip {
                    extraVisibleCondition: shapeHoverArea.containsMouse
                    content: root.title
                }
            }
        }
    }

    // Wrapper Item to handle anchors
    Item {
        visible: expanded
        anchors {
            left: iconLoader?.right ?? parent.right
            right: parent.right
            margins: Padding.normal * mainScale
            leftMargin: Padding.large * mainScale
            rightMargin: (Padding.massive + root.extraRightPadding) * mainScale
            top: parent.top
            bottom: parent.bottom
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            anchors.fill: parent
            spacing: Padding.small

            StyledText {
                id: title
                text: root.title
                Layout.rightMargin: Padding.verylarge
                maximumLineCount: 1
                wrapMode: TextEdit.Wrap
                elide: Text.ElideRight
                Layout.preferredWidth: 240
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Math.max(9, Fonts.sizes.normal * mainScale)
                color: {
                    if (root.active)
                        return root.colors.colOnPrimaryContainer;
                    else
                        return root.colTitle;
                }
            }

            StyledText {
                id: subtext
                visible: text !== "" && font.pixelSize >= 9
                text: root.subtext
                Layout.fillWidth: true
                maximumLineCount: 1
                wrapMode: TextEdit.Wrap
                elide: Text.ElideRight
                Layout.rightMargin: Padding.verylarge
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Fonts.sizes.small * mainScale
                color: root.colSubtext
            }
        }
    }
}
