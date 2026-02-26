import QtQuick
import QtQuick.Layouts
import "dialogs"
import "notifications"
import qs.common
import qs.common.widgets

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: Padding.normal

        UpperWidgetGroup {}

        NotificationList {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    StyledLoader {
        id: dialogLoader
        anchors.fill: parent
        visible: true
        active: GlobalStates.main.dialogs.current.length > 0
        source: Qt.resolvedUrl("dialogs/" + GlobalStates.main.dialogs.current + "Dialog.qml")
        onLoaded: {
            _item.show = true;
            _item.finishAction = () => GlobalStates.main.dialogs.current = "";
        }
    }
}
