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
import "games"
import "movies"

Scope {
    id: scope
    Variants {
        model: MonitorsInfo.all
        StyledPanel {
            id: root
            required property var modelData

            name: "big_view"
            shell: "noon"
            fill: true
            screen: modelData
            exclusiveZone: -1
            _layer: "Overlay"

            mask: Region {
                item: bg
            }

            PaletteGenerator {
                id: paletteGenerator
                source: root.currentPage === 1 && gameCarousel ? Qt.resolvedUrl(gameCarousel.currentItem?.modelData?.coverImage ?? "") : ""
            }

            readonly property var colors: paletteGenerator.colors
            property QtObject states: QtObject {
                property bool sidebarOpen: false
                property bool logoutOpen: false
            }

            property alias currentPage: mainView.currentIndex

            readonly property var gameCarousel: mainView.currentItem?.item?.gameCarousel ?? null
            readonly property var moviesPage: mainView.currentItem?.item ?? null
            readonly property var homePage: mainView.currentItem?.item ?? null

            readonly property var registry: [
                {
                    name: "Home",
                    hasBackground: false,
                    icon: "home",
                    subtitle: "",
                    src: "HomePage.qml"
                },
                {
                    name: "Games",
                    icon: "games",
                    subtitle: "Browse your games",
                    src: "games/GamesPage.qml"
                },
                {
                    name: "Movies",
                    icon: "movie",
                    subtitle: "Do you have popcorn ?",
                    src: "movies/MoviesPage.qml"
                }
            ]

            Connections {
                target: sidebar
                function onSelectedIndexChanged() {
                    mainView.currentIndex = sidebar.selectedIndex;
                }
            }

            Connections {
                target: GamePadService.main

                function onMenuStartPressed() {
                    root.states.sidebarOpen = !root.states.sidebarOpen;
                }
            }

            StyledRect {
                id: bg
                color: root.colors.colLayer0
                anchors.fill: parent

                Item {
                    anchors.fill: parent

                    BlurImage {
                        id: blurImage
                        z: 0
                        visible: root.registry[root.currentPage]?.hasBackground ?? true
                        anchors.fill: parent
                        blur: true
                        tint: true
                        tintColor: root.colors.colShadow
                        blurSize: 4
                        blurMax: 15
                    }

                    BigViewSidebar {
                        id: sidebar
                        z: 99
                        states: root.states
                    }

                    ColumnLayout {
                        id: content
                        z: 2
                        anchors.fill: parent
                        anchors.margins: Padding.veryhuge
                        spacing: 0

                        BigViewTitleBar {
                            states: root.states
                            pageTitle: root.registry[root.currentPage]?.name ?? ""
                            pageIcon: root.registry[root.currentPage]?.icon ?? ""
                            pageSubtitle: root.registry[root.currentPage]?.subtitle ?? ""
                        }

                        StackLayout {
                            id: mainView
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Repeater {
                                model: root.registry
                                StyledLoader {
                                    active: StackLayout.isCurrentItem || status === Loader.Ready
                                    source: modelData.src
                                    onLoaded: {
                                        if (modelData.name === "Home") {
                                            _item.requestPage.connect(name => sidebar.selectedIndex = root.registry.findIndex(item => item.name === name));
                                        }
                                        if ("registry" in _item) {
                                            _item.registry = Qt.binding(() => root.registry);
                                        }
                                        if ("backdrop" in _item) {
                                            blurImage.source = Qt.binding(() => _item.backdrop);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    StyledRect {
                        z: 1
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: (parent.width - (root.currentPage === 1 && gameCarousel ? gameCarousel.cardWidth : parent.width * 0.5)) / 2 + Padding.large
                        color: "transparent"
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop {
                                position: 0.0
                                color: "transparent"
                            }
                            GradientStop {
                                position: 0.7
                                color: Colors.m3.m3shadow
                            }
                            GradientStop {
                                position: 1.0
                                color: Colors.m3.m3shadow
                            }
                        }
                    }

                    StyledRect {
                        z: 1
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: (parent.width - (root.currentPage === 1 && gameCarousel ? gameCarousel.cardWidth : parent.width * 0.5)) / 2 + Padding.large
                        color: "transparent"
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop {
                                position: 0.0
                                color: Colors.m3.m3shadow
                            }
                            GradientStop {
                                position: 0.3
                                color: Colors.m3.m3shadow
                            }
                            GradientStop {
                                position: 1.0
                                color: "transparent"
                            }
                        }
                    }
                }
            }
        }
    }
}
