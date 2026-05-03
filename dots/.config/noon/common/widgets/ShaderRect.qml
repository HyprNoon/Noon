import QtQuick
import qs.common
import qs.common.widgets
import qs.common.functions

StyledRect {
    id: root
    clip: true
    readonly property bool enableShaders: extraShaderCondition && Shaders.enabled
    readonly property bool shouldApplyShaders: enableShaders && ColorUtils.getAlpha(color) < 0.35
    property bool extraShaderCondition: true
    color: Colors.colBackground

    Rectangle {
        z: -2
        anchors.fill: parent
        color: Colors.colLayer0
    }

    StyledLoader {
        anchors.fill: parent
        asynchronous: true
        shown: root.shouldApplyShaders
        sourceComponent: Shaders.currentShaderComp
        onLoaded: {
            _item.z = -1;
            _item.parent = Qt.binding(() => root);
        }
    }
}
