import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.common
import qs.common.functions
import qs.common.utils
import qs.common.widgets
import qs.services
import qs.store

StyledPanel {
    id: root

    property bool hoverMode: true
    property bool pinned: false
    property bool expanded: false
    property bool reveal: revealCondition
    property bool rightMode: barPosition !== "right" // Default to right in horizontal Bars
    property alias selectedCategory: sidebarContent.selectedCategory
    readonly property bool show: !hoverMode
    readonly property bool revealCondition: (mouseArea.containsMouse && hoverMode) || PolkitService.flow !== null
    readonly property int rounding: Rounding.verylarge
    readonly property int appearanceMode: Mem.options.sidebar.appearance.mode
    readonly property string barPosition: Mem.options.bar.behavior.position
    readonly property int sidebarWidth: SidebarData.currentSize(hoverMode, root.expanded, selectedCategory) + auxWidth
    readonly property int auxWidth: sidebarContent.auxVisible && !hoverMode ? SidebarData.currentSize(false, false, sidebarContent.auxCategory) : 0
    readonly property int hoverArea: 2
    readonly property Component detachedWindow: DetachedSidebarWindow {}

    function hide() {
        if (pinned)
            return;

        reveal = false;
        hoverMode = true;
        sidebarContent.selectedCategory = "";
        if (!pinned)
            reset_reveal_conditions();
    }

    function incubate(cat = selectedCategory) {
        if (SidebarData.isIncubatable(cat)) {
            GlobalStates.main.sysDialogs.mode = "incubate";
            GlobalStates.main.sysDialogs.pendingData = cat;
        }
    }
    function detach(cat = selectedCategory) {
        if (SidebarData.isDetachable(cat) || !isDetached()) {
            detachedWindow.createObject(root, {
                category: cat
            });
        }
        hide();
    }
    function isDetached() {
        return SidebarData.detachedContent.includes(root.selectedCategory);
    }
    function reveal_content() {
        hoverMode = false;
        sidebarContent.forceActiveFocus();
    }

    function close_aux() {
        sidebarContent.closeAux();
    }

    function reset_reveal_conditions() {
        root.reveal = Qt.binding(() => {
            return root.revealCondition;
        });
    }

    name: "sidebar"
    visible: true
    implicitWidth: visualContainer.width + bubble.width + Sizes.hyprland.gapsOut + rounding
    exclusiveZone: !hoverMode && pinned ? implicitWidth - rounding : appearanceMode === 3 ? 0 : -1
    aboveWindows: true
    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        bottom: true
        left: !root.rightMode || !pinned
        right: root.rightMode || !pinned
    }

    margins {
        top: !pinned && Mem.options.desktop.shell.mode === "nobuntu" ? 40 : 0
    }

    ScreenActionHint {
        z: -1
        icon: "keyboard_double_arrow_right"
        text: "Drop it Inside Your Shelf !"
        target: dropArea
    }

    Item {
        id: wrapperItem

        opacity: width > root.hoverArea ? 1 : 0
        width: {
            if (!hoverMode)
                return visualContainer.width + bubble.width + Padding.massive;
            else
                return reveal ? visualContainer.width : root.hoverArea;
        }

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: !root.rightMode ? parent.left : undefined
            right: root.rightMode ? parent.right : undefined
        }

        // Files Drop Area
        DropArea {
            id: dropArea
            anchors.fill: parent
            keys: ["text/uri-list"]
            onEntered: NoonUtils.callIpc("sidebar reveal Shelf")
        }

        // Main hover Area
        MouseArea {
            id: mouseArea
            enabled: root.hoverMode
            z: 1000
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            anchors.fill: parent
        }

        StyledRectangularShadow {
            target: visualContainer
        }

        StyledRect {
            id: visualContainer

            width: root.sidebarWidth
            color: sidebarContent.colors.colLayer0
            clip: true
            readonly property int hideMargin: state === "float" ? Sizes.elevationMargin : 0

            anchors {
                top: parent.top
                bottom: parent.bottom

                left: !rightMode ? parent.left : undefined
                right: rightMode ? parent.right : undefined
                leftMargin: !rightMode ? ((!hoverMode || reveal) ? hideMargin : -root.sidebarWidth) : 0
                rightMargin: rightMode ? ((!hoverMode || reveal) ? hideMargin : -root.sidebarWidth) : 0
            }

            Content {
                id: sidebarContent
                panelWindow: root
            }

            states: [
                State {
                    name: "sharp"
                    when: root.appearanceMode === 0

                    PropertyChanges {
                        target: visualContainer

                        topRightRadius: 0
                        bottomRightRadius: 0
                        topLeftRadius: 0
                        bottomLeftRadius: 0
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                    }
                },
                State {
                    name: "convex"
                    when: root.appearanceMode === 1

                    PropertyChanges {
                        target: visualContainer

                        topRightRadius: !root.rightMode ? root.rounding : 0
                        bottomRightRadius: !root.rightMode ? root.rounding : 0
                        topLeftRadius: root.rightMode ? root.rounding : 0
                        bottomLeftRadius: root.rightMode ? root.rounding : 0

                        anchors.topMargin: root.barPosition !== "top" ? Sizes.frameThickness : 0
                        anchors.bottomMargin: root.barPosition !== "bottom" ? Sizes.frameThickness : 0
                    }
                },
                State {
                    name: "concave"
                    when: root.appearanceMode === 2
                    PropertyChanges {
                        target: visualContainer

                        topRightRadius: 0
                        bottomRightRadius: 0
                        topLeftRadius: 0
                        bottomLeftRadius: 0
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                    }
                },
                State {
                    name: "float"
                    when: root.appearanceMode === 3
                    PropertyChanges {
                        target: visualContainer

                        topRightRadius: root.rounding
                        bottomRightRadius: root.rounding
                        topLeftRadius: root.rounding
                        bottomLeftRadius: root.rounding

                        anchors.topMargin: Sizes.elevationMargin
                        anchors.bottomMargin: Sizes.elevationMargin
                    }
                }
            ]
            transitions: Transition {
                Anim {
                    properties: "topRightRadius,bottomRightRadius,topLeftRadius,bottomLeftRadius,anchors.topMargin,anchors.bottomMargin,radius"
                }
            }
            Behavior on anchors.leftMargin {
                Anim {
                    duration: Animations.durations.normal
                    easing.bezierCurve: Animations.curves.emphasized
                }
            }

            Behavior on anchors.rightMargin {
                Anim {
                    duration: Animations.durations.normal
                    easing.bezierCurve: Animations.curves.emphasized
                }
            }

            Behavior on width {
                Anim {
                    duration: Animations.durations.large
                    easing.type: Easing.OutExpo
                }
            }

            Behavior on color {
                CAnim {
                    duration: Animations.durations.verylarge
                }
            }
        }

        SidebarBubble {
            id: bubble

            show: !hoverMode
            rightMode: root.rightMode
            selectedCategory: sidebarContent.selectedCategory
            colors: sidebarContent.colors

            anchors {
                right: !root.rightMode ? undefined : visualContainer.left
                left: root.rightMode ? undefined : visualContainer.right
                bottom: visualContainer.bottom
                margins: Padding.verylarge
            }
        }

        RoundCorner {
            id: c1

            visible: root.appearanceMode === 2
            corner: root.rightMode ? cornerEnum.bottomRight : cornerEnum.bottomLeft
            color: visualContainer.color
            size: root.rounding

            anchors {
                left: root.rightMode ? undefined : visualContainer.right
                right: root.rightMode ? visualContainer.left : undefined
                bottom: visualContainer.bottom
                bottomMargin: root.barPosition === "bottom" ? 0 : Sizes.frameThickness
            }
        }

        RoundCorner {
            visible: c1.visible
            corner: root.rightMode ? cornerEnum.topRight : cornerEnum.topLeft
            color: visualContainer.color
            size: c1.size

            anchors {
                top: visualContainer.top
                left: root.rightMode ? undefined : visualContainer.right
                right: root.rightMode ? visualContainer.left : undefined
                topMargin: root.barPosition === "top" ? 0 : Sizes.frameThickness
            }
        }

        Behavior on width {
            Anim {}
        }
    }

    FocusHandler {
        windows: [root]
        active: show
        onCleared: !pinned ? hide() : null
    }

    Binding {
        target: GlobalStates.main
        property: "sidebar"
        value: root
    }

    IpcHandler {
        target: "sidebar"
        function reveal_aux(cat: string) {
            sidebarContent.toggleAux(cat);
            GlobalStates.main.holdNotif(cat);
        }

        function reveal(cat: string) {
            sidebarContent.changeContent(cat);
        }
        function pin() {
            root.pinned = true;
        }
        function unpin() {
            root.pinned = false;
        }
        function toggle_pin() {
            root.pinned = !root.pinned;
        }

        function hide() {
            root.hide();
        }
    }

    mask: Region {
        item: wrapperItem
    }
}
