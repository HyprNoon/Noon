import qs.common
import qs.common.widgets
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    Layout.fillHeight: true
    Layout.fillWidth: true
    hoverEnabled: true

    ColumnLayout {
        id: colLayout
        anchors.left: parent.left
        anchors.leftMargin: Padding.large
        anchors.verticalCenter: parent.verticalCenter
        spacing: -Padding.tiny

        StyledText {
            id: appId
            Layout.fillWidth: true
            font.pixelSize: Math.max(Math.round(root.height / 4), 12)
            color: Colors.colSubtext
            truncate: true
            text: MonitorsInfo.topLevel?.appId ?? qsTr("Desktop")
            animateChange: true
            horizontalAlignment: Text.AlignLeft
        }

        StyledText {
            Layout.maximumWidth: 240
            Layout.fillWidth: true
            font.pixelSize: Math.round(appId.font.pixelSize * 1.3)
            color: Colors.colOnLayer0
            truncate: true
            text: MonitorsInfo.topLevel?.title ?? `${qsTr("Workspace")} ${monitor?.activeWorkspace?.id ?? 0}`
            animateChange: true
            horizontalAlignment: Text.AlignLeft
        }
    }
}
