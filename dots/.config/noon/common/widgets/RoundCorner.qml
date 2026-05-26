import QtQuick
import QtQuick.Shapes
import qs.common

Item {
    id: root

    enum Corner {
        TopLeft,
        TopRight,
        BottomLeft,
        BottomRight
    }

    property int size: Rounding.verylarge
    property color color: parent?.color ?? Colors.colLayer0
    property int corner: RoundCorner.TopLeft

    width: size
    height: size

    Shape {
        id: shapeItem
        anchors.fill: parent
        antialiasing: true
        preferredRendererType: Shape.CurveRenderer

        property int triggerUpdate: root.corner

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: root.color

            startX: {
                var update = shapeItem.triggerUpdate;
                switch (root.corner) {
                case RoundCorner.TopLeft:
                    return 0;
                case RoundCorner.TopRight:
                    return root.size;
                case RoundCorner.BottomLeft:
                    return 0;
                case RoundCorner.BottomRight:
                    return root.size;
                default:
                    return 0;
                }
            }

            startY: {
                var update = shapeItem.triggerUpdate;
                switch (root.corner) {
                case RoundCorner.TopLeft:
                    return 0;
                case RoundCorner.TopRight:
                    return 0;
                case RoundCorner.BottomLeft:
                    return root.size;
                case RoundCorner.BottomRight:
                    return root.size;
                default:
                    return 0;
                }
            }

            PathAngleArc {
                moveToStart: false
                radiusX: root.size
                radiusY: root.size
                sweepAngle: 90

                centerX: {
                    var update = shapeItem.triggerUpdate;
                    switch (root.corner) {
                    case RoundCorner.TopLeft:
                        return root.size;
                    case RoundCorner.TopRight:
                        return 0;
                    case RoundCorner.BottomLeft:
                        return root.size;
                    case RoundCorner.BottomRight:
                        return 0;
                    default:
                        return 0;
                    }
                }
                centerY: {
                    var update = shapeItem.triggerUpdate;
                    switch (root.corner) {
                    case RoundCorner.TopLeft:
                        return root.size;
                    case RoundCorner.TopRight:
                        return root.size;
                    case RoundCorner.BottomLeft:
                        return 0;
                    case RoundCorner.BottomRight:
                        return 0;
                    default:
                        return 0;
                    }
                }
                startAngle: {
                    var update = shapeItem.triggerUpdate;
                    switch (root.corner) {
                    case RoundCorner.TopLeft:
                        return 180;
                    case RoundCorner.TopRight:
                        return 270;
                    case RoundCorner.BottomLeft:
                        return 90;
                    case RoundCorner.BottomRight:
                        return 0;
                    default:
                        return 0;
                    }
                }
            }

            PathLine {
                x: {
                    var update = shapeItem.triggerUpdate;
                    switch (root.corner) {
                    case RoundCorner.TopLeft:
                        return 0;
                    case RoundCorner.TopRight:
                        return root.size;
                    case RoundCorner.BottomLeft:
                        return 0;
                    case RoundCorner.BottomRight:
                        return root.size;
                    default:
                        return 0;
                    }
                }
                y: {
                    var update = shapeItem.triggerUpdate;
                    switch (root.corner) {
                    case RoundCorner.TopLeft:
                        return 0;
                    case RoundCorner.TopRight:
                        return 0;
                    case RoundCorner.BottomLeft:
                        return root.size;
                    case RoundCorner.BottomRight:
                        return root.size;
                    default:
                        return 0;
                    }
                }
            }
        }
    }
}
