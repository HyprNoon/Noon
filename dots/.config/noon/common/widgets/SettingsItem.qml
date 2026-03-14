import QtQuick.Layouts
import QtQuick
import qs.common
import qs.common.widgets
import qs.services
import Quickshell

StyledRect {
    id: root
    property string icon: ""
    property string name: ""
    property string key: ""
    property string hint: ""
    property string type: "switch"
    property string actionName: ""
    property bool reloadOnChange: false
    property bool enabled: true
    property bool useStates: false
    property bool enableTooltip: true
    property bool hideTitle: type === "field"
    property QtObject colors: Colors
    // Values
    property int customItemHeight: 0
    // TODO ==> merge those values into re
    property int minValue: 0
    property int maxValue: 100
    property int intValue: 0

    property real sliderMinValue: 0
    property real sliderMaxValue: 1
    property real realValue: 0.1

    property var comboBoxValues: []
    property int comboBoxCurrentIndex: 0
    property string comboBoxCurrentValue: comboBoxValues.length > 0 ? comboBoxValues[0] : ""
    property bool toggledState: false
    property bool fillHeight: false
    property string textValue: ""
    property string textPlaceholder: "text"
    property bool _initializing: true
    readonly property var dict: {
        "spin": {
            component: spinComponent,
            isActive: intValue > minValue
        },
        "slider": {
            component: sliderComponent,
            isActive: realValue > sliderMinValue,
            width: 120
        },
        "combobox": {
            component: comboboxComponent,
            width: 165
        },
        "field": {
            component: plainFieldComponent,
            isActive: textValue !== "",
            fillWidth: true
        },
        "text": {
            component: textFieldComponent,
            width: 165
        },
        "action": {
            component: actionComponent
        },
        "switch": {
            component: switchComponent
        }
    }
    signal valueChanged(var newValue)
    signal clicked

    function getConfigRoot() {
        return useStates ? Mem.states : Mem.options;
    }

    function getConfigValue() {
        if (key === "" || !Mem)
            return undefined;

        let keys = key.split('.');
        let current = getConfigRoot();

        for (let i = 0; i < keys.length && current; i++) {
            current = current[keys[i]];
        }
        return current;
    }

    function setConfigValue(value) {
        if (key === "" || !Mem || _initializing)
            return;

        let keys = key.split('.');
        let current = getConfigRoot();

        for (let i = 0; i < keys.length - 1; i++) {
            if (!current[keys[i]])
                current[keys[i]] = {};
            current = current[keys[i]];
        }

        current[keys[keys.length - 1]] = value;
        valueChanged(value);

        if (reloadOnChange) {
            NoonUtils.toast(`Shell Is Reloading in ${reloadShellTimer.interval} ms`, "warning", "warn", "Don't Panic");
            reloadShellTimer.restart();
        }
    }
    Timer {
        id: reloadShellTimer
        interval: 300
        onTriggered: Quickshell.reload(true)
    }
    Component.onCompleted: {
        let val = getConfigValue();
        if (val === undefined || val === null) {
            _initializing = false;
            return;
        }

        switch (type) {
        case "spin":
            intValue = Math.max(minValue, Math.min(maxValue, parseInt(val) || minValue));
            break;
        case "slider":
            realValue = Math.max(sliderMinValue, Math.min(sliderMaxValue, parseFloat(val) || sliderMinValue));
            break;
        case "combobox":
            let idx = comboBoxValues.indexOf(val);
            if (idx >= 0) {
                comboBoxCurrentIndex = idx;
                comboBoxCurrentValue = val;
            }
            break;
        case "text":
        case "field":
            textValue = String(val);
            break;
        default:
            toggledState = Boolean(val);
        }

        _initializing = false;
    }

    Layout.fillHeight: fillHeight
    Layout.preferredHeight: (root.fillHeight && mainLoader.item) ? mainLoader.item.implicitHeight + 2 * Padding.normal : 65
    Layout.fillWidth: true
    color: {
        if (!enabled)
            return colors.colLayer2Disabled;

        if (mouseArea.pressed)
            return colors.colLayer2Active;

        if (mouseArea.containsMouse)
            return colors.colLayer2Hover;

        return colors.colLayer2;
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled && (type === "switch")
        onClicked: {
            toggledState = !toggledState;
            setConfigValue(toggledState);
            root.clicked();
            iconAnimation.start();
        }
        onPressed: feedbackAnimation.start()
    }

    Loader {
        active: root.enableTooltip

        sourceComponent: StyledToolTip {
            extraVisibleCondition: hint !== "" && mouseArea.containsMouse
            content: hint
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Padding.small
        anchors.leftMargin: Padding.large
        anchors.rightMargin: Padding.large
        spacing: Padding.huge

        StyledRect {
            visible: !root.hideTitle
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            radius: 999
            color: root.dict[type].isActive ? colors.colPrimary : colors.colLayer3

            Symbol {
                id: iconSymbol

                fill: 1
                font.pixelSize: 18
                text: icon
                color: root.dict[type].isActive ? colors.colOnPrimary : colors.colOnLayer3
                anchors.centerIn: parent

                SequentialAnimation {
                    id: iconAnimation

                    running: false

                    RotationAnimator {
                        target: iconSymbol
                        from: 0
                        to: 360
                        duration: 250
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on color {
                    CAnim {}
                }
            }
        }

        StyledText {
            visible: !root.hideTitle
            text: name
            color: colors.colOnLayer2
            font.pixelSize: Fonts.sizes.normal
            truncate: true
            Layout.fillWidth: true
        }

        Loader {
            id: mainLoader

            sourceComponent: root.dict[type].component
            Layout.fillWidth: root.dict[type].fillWidth || false
            Layout.minimumWidth: root.dict[type].width || 0
            Layout.fillHeight: root.fillHeight
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

    Component {
        id: spinComponent

        StyledSpinBox {
            value: root.intValue
            from: root.minValue
            to: root.maxValue
            enabled: root.enabled
            onValueChanged: if (value !== root.intValue) {
                root.intValue = value;
                root.setConfigValue(value);
            }
        }
    }

    Component {
        id: sliderComponent

        StyledSlider {
            from: root.sliderMinValue
            to: root.sliderMaxValue
            value: root.realValue
            enabled: root.enabled
            enableTooltip: root.enableTooltip
            onMoved: {
                if (!root._initializing) {
                    root.realValue = value;
                    root.setConfigValue(value);
                }
            }
        }
    }

    Component {
        id: comboboxComponent

        StyledComboBox {
            implicitHeight: 40
            enabled: root.enabled
            model: root.comboBoxValues
            currentIndex: root.comboBoxCurrentIndex
            onActivated: function (index) {
                if (index >= 0 && index < root.comboBoxValues.length && index !== root.comboBoxCurrentIndex) {
                    root.comboBoxCurrentIndex = index;
                    root.comboBoxCurrentValue = root.comboBoxValues[index];
                    root.setConfigValue(root.comboBoxCurrentValue);
                    iconAnimation.start();
                }
            }
        }
    }

    Component {
        id: plainFieldComponent

        MaterialTextField {
            enabled: root.enabled
            text: root.textValue
            font.pixelSize: Fonts.sizes.verylarge
            placeholderText: root.textPlaceholder
            onTextChanged: {
                if (text !== root.textValue)
                    root.textValue = text;
            }
            onAccepted: {
                root.setConfigValue(root.textValue);
                iconAnimation.start();
            }
            Keys.onEscapePressed: focus = false
        }
    }

    Component {
        id: textFieldComponent

        MaterialTextField {
            implicitHeight: 40
            enabled: root.enabled
            text: root.textValue
            placeholderText: {
                let val = root.getConfigValue();
                return (val !== undefined && val !== null) ? String(val) : root.textPlaceholder;
            }
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                if (text !== root.textValue)
                    root.textValue = text;
            }
            onAccepted: {
                root.setConfigValue(root.textValue);
                iconAnimation.start();
            }
        }
    }

    Component {
        id: actionComponent

        RippleButtonWithIcon {
            width: 45
            height: width
            colBackground: root.colors.colLayer3
            materialIcon: "play_arrow"
            materialIconFill: true
            releaseAction: function () {
                let cmd = Directories.scriptsDir + "/" + root.actionName;
                NoonUtils.execDetached(cmd);
                NoonUtils.callIpc("sidebar hide");
            }
        }
    }

    Component {
        id: switchComponent

        StyledSwitch {
            checked: root.toggledState
            scale: 0.87
            enabled: root.enabled
            onCheckedChanged: {
                if (checked !== root.toggledState) {
                    root.toggledState = checked;
                    root.setConfigValue(checked);
                    iconAnimation.start();
                }
            }
        }
    }
}
