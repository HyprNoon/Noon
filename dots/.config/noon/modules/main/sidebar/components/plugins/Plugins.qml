import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.store
import qs.services

LayerRect {
    id: root
    radius: Rounding.verylarge

    property string currentCat: "sidebar"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.huge

        PageHeader {
            id: header
            title: swipeView.currentItem.modelData.group
            subTitle: "Found " + Object.keys(swipeView.currentItem.modelData.data)?.length + " Plugins in " + title

            sideButton {
                visible: true
                materialIcon: "refresh"
                onClicked: PluginsManager.refreshAll()
            }
        }

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Padding.massive

            Binding {
                target: indicator
                property: "currentIndex"
                value: swipeView.currentIndex
            }

            contentItem: ListView {
                model: swipeView.contentModel
                interactive: swipeView.interactive
                currentIndex: swipeView.currentIndex
                spacing: swipeView.spacing
                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: width
                highlightMoveDuration: 0
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                displaced: Transition {
                    Anim {
                        property: "x"
                    }
                }
            }

            Repeater {
                id: repeater
                model: ScriptModel {
                    values: PluginsManager.allPlugins
                }
                StyledRect {
                    required property var modelData
                    color: Colors.colLayer2
                    radius: Rounding.huge
                    property real targetScale: SwipeView.isCurrentItem ? 1.0 : 0.85

                    scale: targetScale
                    Behavior on scale {
                        Anim {}
                    }

                    opacity: SwipeView.isCurrentItem ? 1.0 : 0.5
                    Behavior on opacity {
                        Anim {}
                    }

                    StyledListView {
                        id: list
                        anchors.fill: parent
                        anchors.margins: Padding.huge
                        spacing: Padding.verysmall
                        _model: Object.values(modelData.data)
                        delegate: PluginListItem {
                            required property var modelData
                            required property int index
                            anchors.right: parent?.right
                            anchors.left: parent?.left
                            icon: modelData.icon
                            enabled: modelData?.enabled
                            shape: modelData?.shape
                            group: header?.title
                            name: modelData?.name
                            subtext: modelData?.description ?? ""
                            topRadius: index === 0 ? Rounding.verylarge : Rounding.small
                            bottomRadius: index === list.count ? Rounding.verylarge : Rounding.small
                        }
                    }
                }
            }
        }
        M3PageIndicator {
            id: indicator
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            count: swipeView.contentModel.count
            onCurrentIndexChanged: swipeView.currentIndex = currentIndex
        }
        LayerRect {
            Layout.fillWidth: true
            radius: Rounding.large
            Layout.preferredHeight: 100
            toggled: true
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
