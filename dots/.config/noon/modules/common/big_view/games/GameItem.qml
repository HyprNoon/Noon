import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.functions
import qs.common.utils
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: gameItem
    required property var modelData
    required property int index
    required property bool isSelected
    required property int cardWidth
    required property int cardHeight

    width: cardWidth
    height: ListView.view ? ListView.view.height : cardHeight
    anchors.verticalCenter: parent?.verticalCenter
    z: isSelected ? 2 : 0
    function launch() {
        GameLauncherService.launchGame(modelData.id);
        Globals.common.openGameUI = false;
        NoonUtils.callIpc("global deload");
    }
    Item {
        id: cardContainer
        anchors.centerIn: parent
        width: cardWidth
        height: cardHeight
        scale: gameItem.isSelected ? 1.0 : 0.84
        opacity: gameItem.isSelected ? 1.0 : 0.48
        transformOrigin: Item.Center

        Behavior on scale {
            Anim {}
        }
        Behavior on opacity {
            Anim {}
        }

        StyledRectangularShadow {
            target: cardBg
            visible: gameItem.isSelected
            glowRadius: 50
        }

        StyledRect {
            id: cardBg
            anchors.fill: parent
            color: Colors.colSurfaceContainerHighest
            radius: Rounding.silly
            clip: true

            StyledImage {
                z: 0
                visible: (gameItem.modelData?.coverImage ?? "") !== ""
                anchors.fill: parent
                source: Qt.resolvedUrl(gameItem.modelData?.coverImage ?? "")
                fillMode: Image.PreserveAspectCrop
            }

            MouseArea {
                id: eventArea
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    if (gameItem.isSelected) {
                        GameLauncherService.launchGame(gameItem.modelData?.id);
                    } else {
                        carousel.currentIndex = gameItem.index;
                    }
                }
            }
            Rectangle {
                z: 2
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "transparent"
                    }
                    GradientStop {
                        position: 0.4
                        color: "transparent"
                    }
                    GradientStop {
                        position: 0.9
                        color: Colors.m3.m3shadow
                    }
                    GradientStop {
                        position: 1
                        color: Colors.m3.m3shadow
                    }
                }
                ColumnLayout {
                    z: 3
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: Padding.massive * 2
                    spacing: Padding.small

                    StyledRect {
                        visible: playtimeLabel.text.length > 0
                        Layout.fillWidth: false
                        implicitHeight: 26
                        implicitWidth: playtimeLabel.implicitWidth + Padding.normal * 2
                        radius: 13
                        color: Colors.colSecondaryContainer

                        StyledText {
                            id: playtimeLabel
                            anchors.centerIn: parent
                            text: GameLauncherService.getRecentlyPlayed(gameItem.modelData?.lastPlayed) ?? ""
                            font.pixelSize: Fonts.sizes.small
                            font.family: Fonts.family.variable
                            font.variableAxes: Fonts.variableAxes.main
                            color: Colors.colOnSecondaryContainer
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        ColumnLayout {
                            Layout.fillWidth: true

                            StyledText {
                                text: modelData?.name ?? "undefined"
                                truncate: true
                                Layout.fillWidth: true
                                font.pixelSize: Fonts.sizes.huge
                                font.family: Fonts.family.variable
                                font.variableAxes: Fonts.variableAxes.title
                                color: Colors.colOnSurface

                                Behavior on color {
                                    Anim {}
                                }
                            }
                            StyledText {
                                visible: text.length > 0
                                text: modelData?.description ?? ""
                                Layout.fillWidth: true
                                font.pixelSize: Fonts.sizes.normal
                                font.family: Fonts.family.variable
                                font.variableAxes: Fonts.variableAxes.main
                                color: Colors.colOnSurfaceVariant
                            }
                        }

                        ButtonGroup {
                            opacity: gameItem.isSelected ? 1.0 : 0.0

                            GroupButtonWithIcon {
                                Layout.fillHeight: false
                                Layout.fillWidth: false
                                materialIcon: "delete"
                                colBackground: Colors.colErrorContainer
                                colBackgroundHover: Colors.colErrorContainerHover
                                colBackgroundActive: Colors.colErrorContainerActive
                                implicitSize: 48
                                releaseAction: () => GameLauncherService.deleteGameById(modelData?.id)
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            GroupButtonWithIcon {
                                Layout.fillHeight: false
                                Layout.fillWidth: false
                                materialIcon: "play_arrow"
                                colBackground: Colors.colPrimary
                                colBackgroundHover: Colors.colPrimaryHover
                                colBackgroundActive: Colors.colPrimaryActive
                                implicitSize: 52
                                releaseAction: () => GameLauncherService.launchGameById(modelData?.id)
                            }
                        }
                    }
                }
            }
        }
    }
}
