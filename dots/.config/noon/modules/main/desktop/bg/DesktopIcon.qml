import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.common.utils
import qs.store

Item {
    id: icon
    width: root.iconW
    height: root.iconH

    required property var modelData
    required property int index

    property bool selected: false
    property string appName: modelData.fileBaseName
    property string appIcon: ""
    property string appExec: ""

    readonly property url fileUrl: modelData.fileUrl
    readonly property string fileKey: modelData.fileBaseName

    property real offsetFromLeaderX: 0
    property real offsetFromLeaderY: 0

    readonly property bool groupLeader: canvas.dragLeader === icon
    readonly property bool groupFollower: canvas.dragLeader !== null && canvas.dragLeader !== icon && icon.selected
    readonly property bool groupDragging: groupLeader || groupFollower

    function captureOffsetFromLeader(leader) {
        icon.offsetFromLeaderX = icon.x - leader.x;
        icon.offsetFromLeaderY = icon.y - leader.y;
    }

    Behavior on x {
        enabled: !icon.groupDragging
        Anim {}
    }
    Behavior on y {
        enabled: !icon.groupDragging
        Anim {}
    }

    Binding {
        when: icon.groupFollower
        icon.x: Math.max(0, Math.min(canvas.width - icon.width, canvas.dragLeader.x + icon.offsetFromLeaderX))
        icon.y: Math.max(0, Math.min(canvas.height - icon.height, canvas.dragLeader.y + icon.offsetFromLeaderY))
    }

    transform: [
        Scale {
            origin.x: icon.width / 2
            origin.y: icon.height / 2
            xScale: icon.groupDragging ? 1.06 : 1.0
            yScale: icon.groupDragging ? 1.06 : 1.0
            Behavior on xScale {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutBack
                    easing.overshoot: 2
                }
            }
            Behavior on yScale {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutBack
                    easing.overshoot: 2
                }
            }
        },
        Rotation {
            id: wiggleR
            origin.x: icon.width / 2
            origin.y: icon.height / 2
            angle: 0
        }
    ]

    SequentialAnimation {
        id: wiggleAnim
        running: icon.groupDragging
        loops: Animation.Infinite
        NumberAnimation {
            target: wiggleR
            property: "angle"
            to: 2.0
            duration: 140
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: wiggleR
            property: "angle"
            to: -2.0
            duration: 140
            easing.type: Easing.InOutSine
        }
        onStopped: wiggleR.angle = 0
    }

    function loadPosition() {
        var saved = root.store.positions[icon.fileKey];
        if (saved) {
            icon.x = saved.x;
            icon.y = saved.y;
        } else {
            var p = root.defaultPos(icon.index);
            icon.x = p.x;
            icon.y = p.y;
        }
    }

    Component.onCompleted: loadPosition()

    Connections {
        target: root.store
        function onPositionsChanged() {
            if (!icon.groupDragging)
                icon.loadPosition();
        }
    }

    FileView {
        id: df
        path: icon.modelData.filePath
        onLoaded: {
            var r = root.parseDesktop(df.text());
            icon.appName = r.name || icon.modelData.fileBaseName;
            icon.appIcon = r.icon;
            icon.appExec = r.exec;
        }
        Component.onCompleted: reload()
    }

    StyledRect {
        anchors.fill: parent
        radius: Rounding.verysmall
        color: icon.selected ? Colors.t(Colors.colPrimaryContainer, 0.35) : "transparent"
        enableBorders: icon.selected
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.iconPad
        spacing: Padding.small
        width: parent.width

        StyledIconImage {
            Layout.alignment: Qt.AlignHCenter
            implicitSize: root.iconSize
            source: {
                if (icon.appIcon.startsWith("/")) {
                    return Qt.resolvedUrl(icon.appIcon);
                } else
                    return NoonUtils.iconPath(icon.appIcon, "application-x-executable");
            }

            Behavior on implicitSize {
                Anim {}
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: root.labelWidth
            horizontalAlignment: Text.AlignHCenter
            text: icon.appName
            color: Colors.colOnSurface
            font.pixelSize: root.labelSize
            elide: Text.ElideRight
            maximumLineCount: root.labelLines
            wrapMode: Text.WordWrap
        }
    }

    layer.enabled: icon.groupLeader
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 10
        radius: 22
        samples: 17
        color: Colors.colShadow
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: ma.drag.active ? Qt.ClosedHandCursor : Qt.PointingHandCursor

        drag.target: icon
        drag.axis: Drag.XAndYAxis
        drag.minimumX: 0
        drag.maximumX: canvas.width - icon.width
        drag.minimumY: 0
        drag.maximumY: canvas.height - icon.height
        drag.threshold: 6
        drag.smoothed: true

        onPressed: function (mouse) {
            if (mouse.button === Qt.RightButton)
                return;
            icon.z = 999;
            if (!icon.selected) {
                for (var i = 0; i < rep.count; i++) {
                    var it = rep.itemAt(i);
                    if (it && it !== icon)
                        it.selected = false;
                }
            }
            icon.selected = true;
        }

        onPositionChanged: function (mouse) {
            if (!ma.drag.active)
                return;
            if (canvas.dragLeader === null)
                canvas.beginGroupDrag(icon);
            root.trashHovered = root.iconOverTrash(icon.x, icon.y);
        }

        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                if (!icon.selected) {
                    for (var i = 0; i < rep.count; i++) {
                        var it = rep.itemAt(i);
                        if (it && it !== icon)
                            it.selected = false;
                    }
                    icon.selected = true;
                }
                iconMenu.popup();
            } else if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["bash", "-c", icon.appExec]);
            }
        }

        onReleased: function (mouse) {
            icon.z = 0;
            var wasDragging = ma.drag.active;

            if (!wasDragging) {
                canvas.endGroupDrag();
                return;
            }

            if (root.trashHovered) {
                root.trashHovered = false;
                canvas.endGroupDrag();
                trashSelected();
                return;
            }

            root.trashHovered = false;
            settleAll();
        }

        onDoubleClicked: function (mouse) {
            if (mouse.button === Qt.LeftButton)
                NoonUtils.execDetached(["gio", "launch", icon.fileUrl.toString()]);
        }
    }

    function trashSelected() {
        for (var i = 0; i < rep.count; i++) {
            var it = rep.itemAt(i);
            if (it && it.selected) {
                NoonUtils.execDetached(["gio", "trash", it.modelData.filePath]);
                root.removePosition(it.fileKey);
            }
        }
    }

    function settleAll() {
        var toSettle = [];
        for (var i = 0; i < rep.count; i++) {
            var it = rep.itemAt(i);
            if (it && it.selected)
                toSettle.push({
                    fileKey: it.fileKey,
                    x: it.x,
                    y: it.y,
                    ref: it
                });
        }

        var allKeys = toSettle.map(function (s) {
            return s.fileKey;
        });
        var claimedCells = [];
        var newPositions = Object.assign({}, root.store.positions);

        for (var j = 0; j < toSettle.length; j++) {
            var s = toSettle[j];
            var raw = root.snapToGridEnabled ? root.snapToGrid(s.x, s.y) : Qt.point(s.x, s.y);
            var free = root.nearestFreeCell(raw.x, raw.y, allKeys, claimedCells);
            claimedCells.push({
                x: free.x,
                y: free.y
            });
            newPositions[s.fileKey] = {
                x: free.x,
                y: free.y
            };
            s.ref.x = free.x;
            s.ref.y = free.y;
        }

        canvas.endGroupDrag();
        root.store.positions = newPositions;
    }

    Menu {
        id: iconMenu
        Material.theme: Material.Dark
        Material.accent: Material.Blue
        Material.roundedScale: Material.SmallScale
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            implicitWidth: 200
            color: Colors.colLayer3
            radius: Rounding.normal
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: Rounding.large
                samples: 41
                color: Colors.colShadow
                verticalOffset: 6
            }
        }

        MenuItem {
            text: "Open"
            icon.name: "document-open"
            Material.foreground: "white"
            onTriggered: NoonUtils.execDetached(["gio", "launch", icon.fileUrl.toString()])
            background: Rectangle {
                color: parent.highlighted ? Colors.colLayer3Hover : "transparent"
                radius: Rounding.small
            }
        }

        MenuSeparator {
            contentItem: Separator {}
            background: Item {}
        }

        MenuItem {
            text: "Move to Trash"
            icon.name: "user-trash"
            Material.foreground: "#ff6b6b"
            onTriggered: {
                NoonUtils.deleteFile(icon.modelData.filePath);
                console.log(icon.modelData.filePath);
                root.removePosition(icon.fileKey);
            }
            background: Rectangle {
                color: parent.highlighted ? Colors.colLayer3Hover : "transparent"
                radius: Rounding.small
            }
        }
    }
}
