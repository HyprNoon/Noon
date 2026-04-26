import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

ButtonGroup {
    id: group

    property alias inputArea: inputArea
    height: 60
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.leftMargin: Padding.small
    anchors.rightMargin: Padding.small

    StyledTextField {
        id: inputArea
        visible: root.isSearching
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        focus: true
        height: 60
        color: Colors.colOnLayer3
        Layout.fillWidth: visible
        background: null
        onAccepted: BeatsHitsService.search(inputArea.text)
    }
    Repeater {
        model: ScriptModel {
            values: {
                const l = [
                    {
                        toggled: root.isSearching,
                        icon: "search",
                        action: () => {
                            root.isSearching = !root.isSearching;
                        }
                    },
                    {
                        icon: "refresh",
                        action: () => {
                            root.isSearching = false;
                            BeatsHitsService.refresh();
                        }
                    },
                    {
                        icon: bg.mode === "options" ? "music_note" : "menu",
                        action: () => {
                            if (bg.mode === "options")
                                bg.mode = "preview";
                            else
                                bg.mode = "options";
                        }
                    },
                    {
                        visible: !BeatsService.daemonOptions.isAuth,
                        icon: BeatsService.daemonOptions.isAuth ? "check" : "login",
                        action: () => {
                            BeatsHitsService.auth();
                        }
                    }
                ];
                return l.filter(b => b?.visible ?? true);
            }
        }
        delegate: GroupButtonWithIcon {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillHeight: false
            Layout.fillWidth: false
            toggled: modelData?.toggled ?? false
            baseSize: 55
            materialIcon: modelData.icon
            releaseAction: () => modelData.action()
        }
    }
}
