import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils

AppWindow {
    id: root
    visible: true
    maximumSize: Qt.size(1600, 900)
    minimumSize: Qt.size(1280, 720)
    readonly property Item contentLoaderItem: contentLoader.item
    readonly property Item sidebarContentLoaderItem: sidebarContentLoader.item
    readonly property Item secondarySidebarContentLoaderItem: secondary_sidebar_loader.item
    property var states_target

    property alias secondary_content_item: sidebarContentLoader.sourceComponent
    property alias secondary_sidebar_content_item: secondary_sidebar_loader.sourceComponent
    property alias contentItem: contentLoader.sourceComponent

    property int appearance_mode: Mem.states.applications[states_target].appearance_mode // 0: sharp, 1: convex, 2: concave 3: float
    property bool reveal_tweaks: false

    onAppearance_modeChanged: Mem.states.applications[states_target].appearance_mode = appearance_mode

    StyledRect {
        id: bg
        anchors.fill: parent
        color: Colors.m3.m3surface
    }

    MouseArea {
        id: secondary_sidebar_hover_area
        z: 99
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        // enabled: !sidebar.pinned
        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.NoButton
        width: containsMouse ? secondary_sidebar.width : 5
        propagateComposedEvents: true
    }

    StyledRect {
        id: secondary_sidebar
        z: 2
        visible: secondary_sidebar_loader.item !== null
        readonly property bool show: secondary_sidebar_hover_area.containsMouse

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: show ? 0 : -implicitWidth
        }

        color: Colors.colLayer2
        implicitWidth: 250

        Loader {
            id: secondary_sidebar_loader
            z: 99
            anchors.fill: parent
            active: sourceComponent !== null
            visible: active
            asynchronous: true
            onLoaded: if (item) {
                item.anchors.fill = secondary_sidebar;
                contentLoader.anchors.right = secondary_sidebar.left;
            }
        }
        Rectangle {
            id: secondary_sidebar_border
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            width: 1
            color: Colors.colOutline
        }
        Behavior on anchors.rightMargin {
            Anim {}
        }
    }
    Loader {
        id: contentLoader
        anchors {
            left: sidebar.right
            leftMargin: Padding.large
            margins: Padding.normal
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        Loader {
            id: tweaks_loader
            z: 999
            visible: active
            active: root.reveal_tweaks
            anchors.centerIn: parent
            asynchronous: true
            sourceComponent: tweaks_component
        }
    }
    Loader {
        readonly property var controls: Mem.options.applications.windowControls
        anchors {
            top: parent.top
            right: parent.right
            margins: Padding.massive
        }
        active: controls.minimize || controls.close || controls.maximize
        asynchronous: true
        sourceComponent: ApplicationWindowControls {
            panelWindow: root
        }
    }
    MouseArea {
        id: sidebar_hover_area
        z: 99
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        enabled: !sidebar.pinned
        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.NoButton
        width: containsMouse ? sidebar.width : 5
        propagateComposedEvents: true
    }

    StyledRect {
        id: sidebar
        focus: true
        property bool expanded: (sidebar_expanded_width > Sizes.mediaPlayer.sidebarWidthCollapsed) && Mem.states.applications[states_target].sidebar_expanded
        property bool pinned: Mem.states.applications[states_target].sidebar_pinned
        property int sidebar_expanded_width: Sizes.mediaPlayer.sidebarWidth
        readonly property bool _floating: root.appearance_mode === 3
        readonly property bool shown: sidebar_hover_area.containsMouse || pinned
        onExpandedChanged: Mem.states.applications[states_target].sidebar_expanded = expanded
        onPinnedChanged: Mem.states.applications[states_target].sidebar_pinned = pinned

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: !shown ? -width : _floating ? Padding.large : 0
            margins: _floating ? Padding.large : 0
        }

        enableBorders: _floating
        border.width: 2
        implicitWidth: expanded ? sidebar_expanded_width : Sizes.mediaPlayer.sidebarWidthCollapsed
        color: Colors.colLayer2
        leftRadius: _floating ? Rounding.large : 0
        rightRadius: {
            switch (root.appearance_mode) {
            case 0:
                return 0;
            case 1:
                return Rounding.massive;
            case 2:
                return 0;
            case 3:
                return Rounding.large;
            default:
                return 0;
            }
        }
        Behavior on anchors.leftMargin {
            Anim {}
        }

        Loader {
            id: sidebarContentLoader
            anchors.fill: parent
            sourceComponent: secondary_content_item
        }

        Rectangle {
            visible: root.appearance_mode === 0
            color: Colors.colOutline
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
            width: border_event_area.containsMouse ? 3 : 1
            MouseArea {
                id: border_event_area
                z: 999
                anchors.fill: parent
                hoverEnabled: true
                property int startWidth: 0

                drag {
                    target: parent
                    axis: Drag.XAxis
                }

                cursorShape: containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor
                preventStealing: true

                onPressed: startWidth = sidebar.sidebar_expanded_width
                onPositionChanged: if (drag.active && mouse) {
                    var delta = mouse.x;
                    var newWidth = startWidth + delta;
                    sidebar.sidebar_expanded_width = Math.max(newWidth, 80);
                }
            }
        }
        StyledRect {
            id: sidebar_controls_bg
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: Padding.massive
            }

            implicitHeight: sidebar_controls_grid.implicitHeight + Padding.large
            implicitWidth: sidebar_controls_grid.implicitWidth + Padding.large
            // enableBorders: true
            color: Colors.colLayer2Disabled
            radius: Rounding.verylarge

            GridLayout {
                id: sidebar_controls_grid
                anchors.centerIn: parent
                rows: sidebar.expanded ? 1 : children.length
                columns: sidebar.expanded ? 2 : 1
                ControlButton {
                    visible: false
                    materialIcon: "settings"
                    toggled: root.reveal_tweaks
                    releaseAction: () => {
                        root.reveal_tweaks = !root.reveal_tweaks;
                    }
                }
                ControlButton {
                    materialIcon: "push_pin"
                    toggled: sidebar.pinned
                    releaseAction: () => {
                        sidebar.pinned = !sidebar.pinned;
                    }
                }
                ControlButton {
                    materialIcon: "expand_content"
                    toggled: sidebar.expanded
                    releaseAction: () => {
                        sidebar.expanded = !sidebar.expanded;
                    }
                }
            }
        }
        Keys.onPressed: event => {
            if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_O) {
                sidebar.expanded = !sidebar.expanded;
                event.accepted = true;
            }

            if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_P) {
                sidebar.pinned = !sidebar.pinned;
                event.accepted = true;
            }
        }
    }

    RoundCorner {
        id: top_corner
        visible: root.appearance_mode === 2
        corner: cornerEnum.topLeft
        size: Rounding.massive
        color: sidebar.color
        anchors {
            top: sidebar.top
            left: sidebar.right
        }
    }
    RoundCorner {
        id: bottom_corner
        visible: root.appearance_mode === 2
        corner: cornerEnum.bottomLeft
        size: Rounding.massive
        color: sidebar.color
        anchors {
            bottom: sidebar.bottom
            left: sidebar.right
        }
    }
    Component {
        id: tweaks_component
        Item {
            id: root
            anchors.centerIn: parent

            implicitWidth: 500
            implicitHeight: 400

            StyledRect {
                id: bg
                anchors.fill: parent
                color: Colors.colLayer1
                radius: Rounding.massive
                enableBorders: true
            }
            StyledRectangularShadow {
                target: bg
            }
        }
    }
    StyledRectangularShadow {
        target: sidebar_controls_bg
    }
    StyledRectangularShadow {
        target: sidebar
    }
    StyledRectangularShadow {
        target: secondary_sidebar
    }
    component ControlButton: RippleButtonWithIcon {
        colBackground: Colors.colLayer3
        buttonRadius: Rounding.full
        implicitSize: 34
    }
}
