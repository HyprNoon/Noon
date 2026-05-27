import QtQuick.Layouts
import QtQuick
import qs.common
import qs.common.widgets
import qs.services
import Quickshell

StyledRect {
    id: root
    enabled: true

    property string icon: ""
    property string name: ""
    property string key: ""
    property string type: "switch"
    property string actionName: ""
    property bool reloadOnChange: false
    property string store: "options"
    property QtObject colors: Colors
    readonly property alias component: mainLoader._item
    property int minValue: 0
    property int maxValue: 100
    property real sliderMinValue: 0
    property real sliderMaxValue: 1
    property bool canRefresh: false
    property var refreshAction
    property var comboBoxValues: []
    property bool fillHeight: false
    property string textPlaceholder: "text"

    readonly property var configValue: getConfigValue()

    readonly property var typeMap: ({
            "spin": {
                source: "StyledSpinBox",
                isActive: () => root.configValue > root.minValue,
                props: {
                    from: root.minValue,
                    to: root.maxValue,
                    value: root.configValue
                }
            },
            "slider": {
                source: "StyledSlider",
                isActive: () => root.configValue > root.sliderMinValue,
                width: 120,
                props: {
                    from: root.sliderMinValue,
                    to: root.sliderMaxValue,
                    value: root.configValue
                }
            },
            "combobox": {
                source: "StyledComboBox",
                width: 165,
                props: {
                    model: root.comboBoxValues,
                    currentIndex: Math.max(0, root.comboBoxValues.findIndex(v => (v?.name ?? v) === root.configValue))
                }
            },
            "text": {
                source: "MaterialTextField",
                width: 165,
                props: {
                    implicitHeight: 47,
                    placeholderText: root.textPlaceholder,
                    text: String(root.configValue ?? "")
                }
            },
            "field": {
                source: "MaterialTextField",
                fillWidth: true,
                props: {
                    placeholderText: root.textPlaceholder,
                    text: String(root.configValue ?? "")
                }
            },
            "switch": {
                source: "StyledSwitch",
                props: {
                    checked: !!root.configValue
                }
            },
            "font": {
                source: "StyledFontSelector"
            },
            "action": {
                source: "ActionButton"
            }
        })

    readonly property var currentType: typeMap[type] || typeMap["switch"]
    readonly property bool isActive: currentType.isActive ? currentType.isActive() : !!root.configValue
    readonly property bool hideTitle: type === "field"
    readonly property var base: Mem[(store || "options")] ?? Mem.options
    Layout.fillWidth: true
    Layout.fillHeight: fillHeight
    Layout.preferredHeight: (fillHeight && component) ? component.implicitHeight + 2 * Padding.normal : 72

    color: !enabled ? colors.colLayer2Disabled : mouseArea.pressed ? colors.colLayer2Active : mouseArea.containsMouse ? colors.colLayer2Hover : colors.colLayer2

    function getConfigValue() {
        if (key === "" || !Mem)
            return undefined;
        return key.split('.').reduce((cur, k) => cur?.[k], base);
    }

    function startReloadDialog() {
        NoonUtils.requestDialog("assure", {
            title: "Restart",
            description: "For changes to take Effect",
            acceptText: "Accept",
            onAccepted: () => NoonUtils.execDetached(Directories.scriptsDir + "/reload_shell.sh")
        });
    }

    function setConfigValue(value) {
        if (key === "" || !Mem)
            return;
        const parts = key.split('.');
        const target = parts.slice(0, -1).reduce((cur, k) => cur[k] || (cur[k] = {}), base);

        target[parts[parts.length - 1]] = value;

        if (reloadOnChange)
            startReloadDialog();
    }

    Connections {
        target: root.component
        ignoreUnknownSignals: true

        function onClicked() {
            feedbackAnimation.start();
            iconAnimation.start();
            root.getConfigValue();
            root.setConfigValue(root.component.checked);
        }

        function onMoved() {
            root.setConfigValue(root.component.value);
        }

        function onValueChanged() {
            root.setConfigValue(root.component.value);
        }

        function onEditingFinished() {
            root.setConfigValue(root.component.text);
        }

        function onCurrentIndexChanged() {
            const val = root.comboBoxValues[root.component.currentIndex];
            root.setConfigValue(val?.name ?? val ?? "");
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled && type === "switch"
        onClicked: root.component?.click()
    }

    RowLayout {
        anchors.fill: parent
        // anchors.margins: Padding.large
        anchors.leftMargin: Padding.veryhuge
        anchors.rightMargin: Padding.veryhuge
        spacing: Padding.massive

        StyledRect {
            visible: !root.hideTitle
            Layout.preferredHeight: 45
            Layout.preferredWidth: 45
            radius: Rounding.full
            color: root.isActive ? colors.colPrimary : colors.colLayer3

            Symbol {
                id: iconSymbol
                fill: 1
                font.pixelSize: 20
                text: root.icon
                color: root.isActive ? colors.colOnPrimary : colors.colOnLayer3
                anchors.centerIn: parent
                Behavior on color {
                    CAnim {}
                }

                SequentialAnimation {
                    id: iconAnimation
                    RotationAnimator {
                        target: iconSymbol
                        from: 0
                        to: 360
                        duration: 250
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        StyledText {
            visible: !root.hideTitle
            text: root.name
            color: colors.colOnLayer2
            font.pixelSize: Fonts.sizes.normal
            truncate: true
            Layout.fillWidth: true
        }

        StyledLoader {
            id: mainLoader
            source: sanitizeSource("", root.currentType.source)
            Layout.fillWidth: root.currentType.fillWidth ?? false
            Layout.minimumWidth: root.currentType.width ?? 0
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: root.fillHeight
            onLoaded: {
                if ("enabled" in item)
                    item.enabled = Qt.binding(() => root.enabled);
                const props = root.currentType.props || {};
                Object.keys(props).forEach(prop => {
                    if (prop in item)
                        item[prop] = Qt.binding(() => props[prop]);
                });
            }
        }

        StyledLoader {
            id: refreshLoader
            Layout.leftMargin: -Padding.verylarge
            shown: root.canRefresh
            sourceComponent: RippleButtonWithIcon {
                materialIcon: "refresh"
                // colBackground: "transparent"
                implicitSize: 45
                releaseAction: () => root.refreshAction()
            }
        }
    }

    SequentialAnimation {
        id: feedbackAnimation
        ScaleAnimator {
            target: root
            from: 1
            to: 0.98
            duration: 50
        }
        ScaleAnimator {
            target: root
            from: 0.98
            to: 1
            duration: 100
        }
    }
}
