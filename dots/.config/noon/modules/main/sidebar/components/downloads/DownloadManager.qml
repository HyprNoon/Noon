import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services
import Noon.Utils.Download
import "./"

StyledRect {
    id: root
    visible: opacity > 0
    opacity: width > 320 ? 1 : 0
    color: Colors.colLayer1
    radius: Rounding.verylarge
    clip: true

    PagePlaceholder {
        implicitWidth: 400
        implicitHeight: 400
        anchors.centerIn: parent
        icon: "download"
        shown: DownloadService.model.count === 0
        title: "No Active Downloads"
        description: "Currently Active Downloads show here"
    }

    StyledListView {
        anchors.fill: parent
        model: DownloadService.model
        animateAppearance: true
        animateMovement: true
        popin: true
        delegate: DownloadDelegatedItem {
            anchors {
                right: parent?.right
                left: parent?.left
                margins: Padding.normal
            }
        }
    }
}
