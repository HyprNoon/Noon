import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

PopupWindow {
    id: root

    required property QsMenuHandle trayItemMenuHandle
    property real popupBackgroundMargin: 0
    property real padding: Sizes.elevationMargin

    signal menuClosed
    signal menuOpened(var qsWindow) // Correct type is QsWindow, but QML does not like that

    function open() {
        root.visible = true;
        root.menuOpened(root);
    }

    function close() {
        root.visible = false;
        while (stackView.depth > 1)
            stackView.pop();
        root.menuClosed();
    }

    color: "transparent"
    implicitHeight: {
        let result = 0;
        for (let child of stackView.children) {
            result = Math.max(child.implicitHeight, result);
        }
        return result + popupBackground.padding * 2 + root.padding * 2;
    }
    implicitWidth: {
        let result = 0;
        for (let child of stackView.children) {
            result = Math.max(child.implicitWidth, result);
        }
        return result + popupBackground.padding * 2 + root.padding * 2;
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.BackButton | Qt.RightButton
        onPressed: event => {
            // Handle back/right button for navigation
            if ((event.button === Qt.BackButton || event.button === Qt.RightButton) && stackView.depth > 1) {
                stackView.pop();
                event.accepted = true;
                return;
            }
            // Handle left click - close if outside popup
            if (event.button === Qt.LeftButton) {
                let clickPos = mapToItem(popupBackground, event.x, event.y);
                if (clickPos.x < 0 || clickPos.y < 0 || clickPos.x > popupBackground.width || clickPos.y > popupBackground.height) {
                    root.close();
                    event.accepted = true;
                } else {
                    event.accepted = false; // Let the click through to menu items
                }
            }
        }

        StyledRect {
            id: popupBackground

            readonly property real padding: 4

            color: Colors.colLayer0
            radius: Rounding.large
            opacity: 0
            Component.onCompleted: opacity = 1
            implicitWidth: stackView.implicitWidth + popupBackground.padding * 2
            implicitHeight: stackView.implicitHeight + popupBackground.padding * 2

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: Mem.options.bar.vertical ? parent.verticalCenter : undefined
                top: Mem.options.bar.vertical ? undefined : Mem.options.bar.bottom ? undefined : parent.top
                bottom: Mem.options.bar.vertical ? undefined : Mem.options.bar.bottom ? parent.bottom : undefined
                margins: root.padding
            }

            StackView {
                id: stackView

                anchors.fill: parent
                anchors.margins: popupBackground.padding
                implicitWidth: currentItem.implicitWidth
                implicitHeight: currentItem.implicitHeight

                pushEnter: NoAnim {}

                pushExit: NoAnim {}

                popEnter: NoAnim {}

                popExit: NoAnim {}

                initialItem: SubMenu {
                    handle: root.trayItemMenuHandle
                }
            }

            Behavior on opacity {
                Anim {}
            }

            Behavior on implicitHeight {
                Anim {}
            }

            Behavior on implicitWidth {
                Anim {}
            }
        }
    }

    Component {
        id: subMenuComponent

        SubMenu {}
    }

    component NoAnim: Transition {
        NumberAnimation {
            duration: 0
        }
    }

    component SubMenu: ColumnLayout {
        id: submenu

        required property QsMenuHandle handle
        property bool isSubMenu: false
        property bool shown: false

        opacity: shown ? 1 : 0
        Component.onCompleted: shown = true
        StackView.onActivating: shown = true
        StackView.onDeactivating: shown = false
        StackView.onRemoved: destroy()
        spacing: 0

        QsMenuOpener {
            id: menuOpener

            menu: submenu.handle
        }

        Loader {
            Layout.fillWidth: true
            visible: submenu.isSubMenu
            active: visible

            sourceComponent: RippleButton {
                id: backButton

                buttonRadius: popupBackground.radius - popupBackground.padding
                horizontalPadding: 12
                implicitWidth: contentItem.implicitWidth + horizontalPadding * 2
                implicitHeight: 36
                downAction: () => {
                    return stackView.pop();
                }

                contentItem: RowLayout {
                    spacing: 8

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        right: parent.right
                        leftMargin: backButton.horizontalPadding
                        rightMargin: backButton.horizontalPadding
                    }

                    Symbol {
                        font.pixelSize: 20
                        text: "chevron_left"
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: qsTr("Back")
                    }
                }
            }
        }

        Repeater {
            id: menuEntriesRepeater

            property bool iconColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].icon.length > 0)
                        return true;
                }
                return false;
            }
            property bool specialInteractionColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].buttonType !== QsMenuButtonType.None)
                        return true;
                }
                return false;
            }

            model: menuOpener.children

            delegate: SysTrayMenuEntry {
                required property QsMenuEntry modelData

                forceIconColumn: menuEntriesRepeater.iconColumnNeeded
                forceSpecialInteractionColumn: menuEntriesRepeater.specialInteractionColumnNeeded
                menuEntry: modelData
                buttonRadius: popupBackground.radius - popupBackground.padding
                onDismiss: root.close()
                onOpenSubmenu: handle => {
                    stackView.push(subMenuComponent.createObject(null, {
                        "handle": handle,
                        "isSubMenu": true
                    }));
                }
            }
        }

        Behavior on opacity {
            Anim {}
        }
    }
}
