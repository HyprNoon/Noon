import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import "./../components"

Item {
    id: root
    required property var barRoot
    readonly property var opts: Mem.options.bar.vMap

    anchors {
        fill: parent
        topMargin: Padding.huge
        bottomMargin: Padding.huge
    }

    CLayout {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        spacing: opts.spacing
        BarModulesFactory {
            vertical: true
            model: opts.topArea
        }
    }

    CLayout {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }
        spacing: opts.spacing
        BarModulesFactory {
            vertical: true
            model: opts.centerArea
        }
    }
    CLayout {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        spacing: opts.spacing
        BarModulesFactory {
            vertical: true
            model: opts.bottomArea
        }
    }
}
