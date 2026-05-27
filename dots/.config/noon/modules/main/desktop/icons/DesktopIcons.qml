import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Io
import Qt.labs.folderlistmodel
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services
import qs.store

Variants {
    model: MonitorsInfo.all

    StyledPanel {
        id: root
        visible: false
        required property var modelData
        screen: modelData
        name: "desktop_widgets_layer"
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Bottom
        fill: true

        margins {
            top: Padding.normal
            bottom: Padding.normal
            right: Padding.normal
            left: Padding.normal
        }

        readonly property var store: Mem.states.desktop.icons

        readonly property int iconSize: store.iconSize
        readonly property int sortMode: store.sortMode
        readonly property bool snapToGridEnabled: store.snapToGrid

        readonly property int labelSize: Math.max(9, Math.round(iconSize * 0.2))
        readonly property int labelWidth: Math.max(60, iconSize + 20)
        readonly property int labelLines: iconSize >= 64 ? 2 : 1
        readonly property int iconPad: 8
        readonly property int iconW: labelWidth + iconPad * 2
        readonly property int iconH: iconSize + labelSize * labelLines + 16 + iconPad
        readonly property int cellW: iconW + 12
        readonly property int cellH: iconH + 10
        readonly property int iconsPerCol: Math.max(1, Math.floor((height - 20) / cellH))

        property bool rubberActive: false
        property real rubberX1: 0
        property real rubberY1: 0
        property real rubberX2: 0
        property real rubberY2: 0
        property bool trashHovered: false

        readonly property real rubberLeft: Math.min(rubberX1, rubberX2)
        readonly property real rubberTop: Math.min(rubberY1, rubberY2)
        readonly property real rubberRight: Math.max(rubberX1, rubberX2)
        readonly property real rubberBottom: Math.max(rubberY1, rubberY2)

        function defaultPos(index) {
            var col = Math.floor(index / root.iconsPerCol);
            var row = index % root.iconsPerCol;
            return Qt.point(10 + col * root.cellW, 10 + row * root.cellH);
        }

        function snapToGrid(x, y) {
            return Qt.point(Math.round(x / root.cellW) * root.cellW, Math.round(y / root.cellH) * root.cellH);
        }

        function setPosition(key, x, y) {
            var p = Object.assign({}, root.store.positions);
            p[key] = {
                x: x,
                y: y
            };
            root.store.positions = p;
        }

        function removePosition(key) {
            var p = Object.assign({}, root.store.positions);
            delete p[key];
            root.store.positions = p;
        }

        function occupiedCells(excludeKeys, extraOccupied) {
            var cells = {};
            var keys = Object.keys(root.store.positions);
            for (var i = 0; i < keys.length; i++) {
                if (excludeKeys.indexOf(keys[i]) !== -1)
                    continue;
                var pos = root.store.positions[keys[i]];
                cells[pos.x + "," + pos.y] = true;
            }
            if (extraOccupied) {
                for (var j = 0; j < extraOccupied.length; j++)
                    cells[extraOccupied[j].x + "," + extraOccupied[j].y] = true;
            }
            return cells;
        }

        function nearestFreeCell(sx, sy, excludeKey, extraOccupied) {
            var occupied = occupiedCells(Array.isArray(excludeKey) ? excludeKey : [excludeKey], extraOccupied || []);
            if (!occupied[sx + "," + sy])
                return Qt.point(sx, sy);
            var visited = {};
            var queue = [[sx, sy]];
            visited[sx + "," + sy] = true;
            var dirs = [[root.cellW, 0], [-root.cellW, 0], [0, root.cellH], [0, -root.cellH], [root.cellW, root.cellH], [-root.cellW, root.cellH], [root.cellW, -root.cellH], [-root.cellW, -root.cellH]];
            while (queue.length > 0) {
                var cur = queue.shift();
                for (var d = 0; d < dirs.length; d++) {
                    var nx = cur[0] + dirs[d][0];
                    var ny = cur[1] + dirs[d][1];
                    var cellKey = nx + "," + ny;
                    if (visited[cellKey])
                        continue;
                    if (nx < 0 || ny < 0 || nx + root.iconW > canvas.width || ny + root.iconH > canvas.height)
                        continue;
                    visited[cellKey] = true;
                    if (!occupied[cellKey])
                        return Qt.point(nx, ny);
                    queue.push([nx, ny]);
                }
            }
            return Qt.point(sx, sy);
        }

        function arrangeIcons() {
            root.store.positions = {};
        }

        function snapAllToGrid() {
            var keys = Object.keys(root.store.positions);
            var p = {};
            for (var i = 0; i < keys.length; i++) {
                var old = root.store.positions[keys[i]];
                var snapped = root.snapToGrid(old.x, old.y);
                p[keys[i]] = {
                    x: snapped.x,
                    y: snapped.y
                };
            }
            root.store.positions = p;
        }

        function iconInRubber(ix, iy) {
            return ix + root.iconW > root.rubberLeft && ix < root.rubberRight && iy + root.iconH > root.rubberTop && iy < root.rubberBottom;
        }

        function iconOverTrash(ix, iy) {
            var tx = canvas.width - root.iconW - 10;
            var ty = canvas.height - root.iconH - 10;
            return ix + root.iconW > tx && ix < tx + root.iconW && iy + root.iconH > ty && iy < ty + root.iconH;
        }

        function parseDesktop(text) {
            var r = {
                name: "",
                icon: "",
                exec: ""
            };
            var lines = text.split("\n");
            var inEntry = false;
            var localName = "";

            for (var i = 0; i < lines.length; i++) {
                var l = lines[i].trim();

                if (l === "[Desktop Entry]") {
                    inEntry = true;
                    continue;
                }

                if (inEntry && l.startsWith("["))
                    break;

                if (!inEntry || l === "" || l.startsWith("#"))
                    continue;

                var match = l.match(/^([^=]+)\s*=\s*(.*)$/);
                if (!match)
                    continue;

                var key = match[1].trim();
                var value = match[2].trim();

                if (/^Name\[en/.test(key)) {
                    localName = value;
                } else if (key === "Name") {
                    r.name = value;
                } else if (key === "Icon") {
                    r.icon = value;
                } else if (key === "Exec") {
                    // Extracts value and safely strips %u, %U, %f, %F, etc.
                    r.exec = value.replace(/%[fFuuAaCcCcDdFfGgHhiImMnnNvv]/g, "").trim();
                }
            }

            if (localName)
                r.name = localName;

            return r;
        }

        mask: Region {
            item: canvas
        }

        DesktopCanvas {
            id: canvas
            anchors.fill: parent
        }
    }
}
