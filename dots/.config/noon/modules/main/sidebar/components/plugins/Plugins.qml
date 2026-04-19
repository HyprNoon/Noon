import Qt5Compat.GraphicalEffects
import QtQuick.Effects
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
    color: Colors.colLayer1
    radius: Rounding.verylarge

    property string currentCat: "sidebar"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.huge

        StyledText {
            id: groupTitle
            Layout.margins: Padding.huge
            text: swipeView.currentItem.modelData.group
            color: Colors.colOnLayer0
            font.pixelSize: Fonts.sizes.title
            font.variableAxes: Fonts.variableAxes.title
            Layout.preferredHeight: 40
        }

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Padding.massive

            Repeater {
                model: ScriptModel {
                    values: PluginsManager.allPlugins
                }
                StyledRect {
                    required property var modelData
                    color: Colors.colLayer2
                    radius: Rounding.huge

                    StyledListView {
                        id: list
                        anchors.fill: parent
                        anchors.margins: Padding.huge
                        spacing: Padding.small
                        model: ScriptModel {
                            id: itemsModel
                            values: Object.values(modelData.data)
                        }
                        delegate: PluginListItem {
                            required property var modelData
                            required property int index
                            anchors.right: parent?.right
                            anchors.left: parent?.left
                            icon: modelData.icon
                            enabled: modelData?.enabled
                            shape: modelData?.shape
                            group: groupTitle?.text
                            name: modelData?.name
                            subtext: modelData?.description ?? ""
                            topRadius: index === 0 ? Rounding.verylarge : Rounding.small
                            bottomRadius: index === itemsModel.values.length - 1 ? Rounding.verylarge : Rounding.small
                        }
                    }
                }
            }
        }

        StyledRect {
            Layout.fillWidth: true
            radius: Rounding.large
            Layout.preferredHeight: 100
            color: Colors.colPrimary

            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Padding.massive
                anchors.left: parent.left
                spacing: Padding.normal
                StyledText {
                    text: "Add New Plugin"
                    color: Colors.colOnPrimary
                    font.variableAxes: Fonts.variableAxes.title
                    font.pixelSize: Fonts.sizes.large
                }
                StyledText {
                    text: "tar.gz, zip, etc"
                    color: Colors.colOnPrimary
                    font.pixelSize: Fonts.sizes.normal
                }
            }

            GroupButtonWithIcon {
                anchors.right: parent.right
                anchors.rightMargin: Padding.massive
                anchors.verticalCenter: parent.verticalCenter
                implicitSize: 50
                buttonRadius: Rounding.normal
                buttonRadiusPressed: Rounding.small
                materialIcon: "attach_file_add"
                releaseAction: () => PluginsManager.selectAndInstall()
                altAction: () => newPluginDialog.show = true
            }
        }
    }
    NewPluginDialog {
        id: newPluginDialog
    }
}
