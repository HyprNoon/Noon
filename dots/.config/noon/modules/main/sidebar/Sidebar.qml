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

Variants {
    model: MonitorsInfo.main

    StyledPanel {
        id: root

        fill: true
        screen: modelData
        shell: "noon"
        name: "blurred_layer"
        _layer: "Top"
        implicitWidth: !pinned ? Screen.width : bg.width + bubble.width + Sizes.hyprland.gapsOut + rounding
        aboveWindows: true
        keyboardFocus: true
        anchors.left: !root.rightMode || !pinned
        anchors.right: root.rightMode || !pinned
        exclusiveZone: pinned ? sidebarWidth : 0

        mask: Region {
            Region {
                item: hoverArea
            }
            Region {
                item: bg
            }
            Region {
                item: bubble
            }
        }

        property bool hoverMode: true
        property bool pinned: false
        property bool expanded: false
        property bool reveal: revealCondition
        property int selectedTabIndex: 0
        property alias selectedCategory: content.selectedCategory

        required property var modelData
        readonly property bool opposeBar: true
        readonly property bool rightMode: opposeBar ? barPosition !== "right" : barPosition !== "left"
        readonly property bool show: !hoverMode
        readonly property bool revealCondition: (!hoverMode || hoverArea.containsMouse || content.hovered) || PolkitService.flow !== null
        readonly property int rounding: Rounding.verylarge
        readonly property string barPosition: Mem.options.bar.behavior.position
        readonly property int sidebarWidth: SidebarData.currentSize(hoverMode, root.expanded, selectedCategory) + auxWidth
        readonly property int auxWidth: content.auxVisible && !hoverMode ? SidebarData.currentSize(false, false, content.auxCategory) : 0
        readonly property int hoverArea: 2
        readonly property Component detachedWindow: DetachedSidebarWindow {}

        function hide() {
            if (pinned)
                return;
            reveal = false;
            hoverMode = true;
            selectedTabIndex = 0;
            content.selectedCategory = "";
            if (!pinned)
                reset_reveal_conditions();
        }

        function incubate(cat = selectedCategory) {
            if (SidebarData.isIncubatable(cat)) {
                GlobalStates.main.sysDialogs.mode = "incubate";
                GlobalStates.main.sysDialogs.pendingData = cat;
                Mem.states.desktop.dialogs.lastIncubatedCategory = cat;
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
        function setTab(tab) {
            if (tab)
                root.selectedTabIndex = tab;
        }
        function reveal_content(selectedTab = 0) {
            hoverMode = false;
            content.forceActiveFocus();
        }

        function close_aux() {
            content.closeAux();
        }

        function reset_reveal_conditions() {
            root.reveal = Qt.binding(() => {
                return root.revealCondition;
            });
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

        HoverHandler {
            id: hoverArea
            implicitWidth: root.hoverArea
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: !root.rightMode ? parent.left : undefined
            anchors.right: root.rightMode ? parent.right : undefined
        }

        ScreenActionHintPanel {
            target: dropArea
            hint: {
                "icon": "keyboard_double_arrow_right",
                "text": "Drop it Inside Your Shelf !"
            }
        }

        // Files Drop Area
        DropArea {
            id: dropArea
            anchors.fill: parent
            keys: ["text/uri-list"]
            onEntered: NoonUtils.callIpc("sidebar reveal Shelf")
        }

        StyledRectangularShadow {
            target: bg
            show: root.reveal
        }

        ShaderRect {
            id: bg

            width: root.sidebarWidth
            readonly property int hideMargin: state === "float" ? Sizes.elevationMargin : 0
            animationDuration: Animations.durations.normal
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            anchors.left: !rightMode ? parent.left : undefined
            anchors.right: rightMode ? parent.right : undefined
            anchors.leftMargin: !rightMode ? ((!hoverMode || reveal) ? hideMargin : -root.sidebarWidth) : 0
            anchors.rightMargin: rightMode ? ((!hoverMode || reveal) ? hideMargin : -root.sidebarWidth) : 0
            state: Mem.options.sidebar.appearance?.style ?? "float"

            Content {
                id: content
                panelWindow: root
                selectedTabIndex: root.selectedTabIndex
            }

            states: [
                State {
                    name: "float"
                    PropertyChanges {
                        target: bg
                        radius: root.rounding
                        enableBorders: true
                        border.color: content.rail.color
                        anchors.topMargin: Sizes.elevationMargin
                        anchors.bottomMargin: Sizes.elevationMargin
                    }
                },
                State {
                    name: "convex"

                    PropertyChanges {
                        target: bg

                        rightRadius: root.rightMode ? 0 : root.rounding
                        leftRadius: !root.rightMode ? 0 : root.rounding
                    }
                },
                State {
                    name: "sharp"
                },
                State {
                    name: "concave"
                }
            ]

            Behavior on anchors.leftMargin {
                Anim {
                    duration: bg.animationDuration
                    easing.bezierCurve: Animations.curves.emphasized
                }
            }

            Behavior on anchors.rightMargin {
                Anim {
                    duration: bg.animationDuration
                    easing.bezierCurve: Animations.curves.emphasized
                }
            }
        }

        SidebarBubble {
            id: bubble

            show: !hoverMode
            rightMode: root.rightMode
            selectedCategory: content.selectedCategory
            colors: content.colors
            sidebarBg: bg
        }

        RoundCorner {
            id: c1

            visible: bg.state === "concave"
            corner: root.rightMode ? RoundCorner.BottomRight : RoundCorner.BottomLeft
            color: root.hoverMode ? content.rail.color : content.colors.colLayer0
            size: root.rounding

            anchors.left: root.rightMode ? undefined : bg.right
            anchors.right: root.rightMode ? bg.left : undefined
            anchors.bottom: bg.bottom
            anchors.bottomMargin: root.barPosition === "bottom" ? 0 : Sizes.frameThickness
        }

        RoundCorner {
            corner: root.rightMode ? RoundCorner.TopRight : RoundCorner.TopLeft

            visible: c1.visible
            color: c1.color
            size: c1.size
            anchors.left: c1.anchors.left
            anchors.right: c1.anchors.right

            anchors.top: bg.top
            anchors.topMargin: root.barPosition === "top" ? 0 : Sizes.frameThickness
        }

        IpcHandler {
            target: "sidebar"
            function reveal_aux(cat: string) {
                content.toggleAux(cat);
                GlobalStates.main.holdNotif(cat);
            }

            function reveal(cat: string) {
                content.changeContent(cat);
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
    }
}
