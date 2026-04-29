import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root

    readonly property PwNode node: modelData

    implicitHeight: rowLayout.implicitHeight

    PwObjectTracker {
        objects: [node]
    }

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        spacing: Padding.large

        StyledIconImage {
            visible: source != ""
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            implicitSize: 50
            source: {
                let icon;
                icon = AppSearch.guessIcon(root.node.properties["application.icon-name"]);
                if (AppSearch.iconExists(icon))
                    return NoonUtils.iconPath(icon);

                icon = AppSearch.guessIcon(root.node.properties["node.name"]);
                return NoonUtils.iconPath(icon);
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: -1

            StyledText {
                Layout.fillWidth: true
                font.pixelSize: Fonts.sizes.normal
                font.variableAxes: Fonts.variableAxes.main
                truncate: true
                text: {
                    const app = root.node.properties["application.name"] ?? (root.node.description != "" ? root.node.description : root.node.name);
                    const media = root.node.properties["media.name"];
                    return media != undefined ? `${app} • ${media}` : app;
                }
            }
            StyledSlider {
                value: root.node.audio.volume
                onMoved: root.node.audio.volume = value
            }
        }
    }
}
