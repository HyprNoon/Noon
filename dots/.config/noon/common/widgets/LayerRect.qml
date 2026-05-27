import QtQuick
import qs.common
import qs.common.widgets
import qs.common.functions

StyledRect {
    id: root
    clip: true
    property bool toggled: false
    property color colBackground: Colors.colLayer1
    property color activeColor: toggled ? Colors.colPrimary : Colors.colLayer1
    color: !Shaders.enabled ? colBackground : Colors.t(activeColor, 0.3)
    // enableBorders: Shaders.enabled
}
