import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services
import Noon.Utils.Download

LayerRect {
    id: root
    visible: opacity > 0
    opacity: width > 320 ? 1 : 0
    radius: Rounding.verylarge
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.large
        spacing: Padding.normal

        StyledSwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex
            Repeater {
                model: tabBar.tabButtonList
                delegate: DownloadsList {
                    finished: modelData.name === "Done"
                }
            }
        }

        PrimaryTabBar {
            id: tabBar
            tabButtonList: [
                {
                    icon: "download",
                    name: "Active"
                },
                {
                    icon: "check",
                    name: "Done"
                }
            ]
            externalTrackedTab: swipeView.currentIndex
        }
    }
    DownloadSettingsDialog {}
    component DownloadsList: Item {
        id: listRoot
        property bool finished

        StyledListView {
            id: list
            anchors.fill: parent
            animateAppearance: true
            animateMovement: true
            popin: true
            _model: DownloadService.model.filter(item => listRoot.finished ? item.state === DownloadItem.State.Finished : item.state !== DownloadItem.State.Finished)
            delegate: DownloadDelegatedItem {}
        }
        PagePlaceholder {
            z: 999
            implicitWidth: 400
            implicitHeight: 400
            anchors.centerIn: parent
            shape: listRoot.finished ? MaterialShape.Cookie9Sided : MaterialShape.PixelCircle
            icon: listRoot.finished ? "check" : "download"
            shown: list.count === 0
            title: listRoot.finished ? "No Finished Downloads" : "No Active Downloads"
            description: listRoot.finished ? "Your completed downloads will appear here" : "Your active downloads will appear here"
        }
    }
}
