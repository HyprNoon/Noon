import QtQuick
import qs.common
import qs.common.widgets

ShaderRect {
    id: root

    property bool reveal: false
    readonly property var conf: Mem.options.beam.appearance
    readonly property real animationScale: conf.animationScale ?? 1
    readonly property int animationStyle: {
        const dict = {
            "expo": BeamBg.Style.Expo,
            "slidebottom": BeamBg.Style.SlideBottom,
            "springpop": BeamBg.Style.SpringPop,
            "overshoot": BeamBg.Style.Overshoot,
            "morphin": BeamBg.Style.MorphIn
        };
        const s = conf.animationStyle ?? "expo";
        return dict[s.toLowerCase()] ?? BeamBg.Style.Expo;
    }

    property int rounding: Rounding.full
    property int elevationValue: 0

    property real translateY: 0
    property real morphWidth: implicitWidth
    readonly property bool _noScale: animationStyle === BeamBg.Style.SlideBottom || animationStyle === BeamBg.Style.MorphIn
    readonly property real _hiddenTranslateY: animationStyle === BeamBg.Style.SlideBottom ? root.elevationValue + root.implicitHeight * 0.4 : root.elevationValue + 10

    enum Style {
        Expo,
        SlideBottom,
        SpringPop,
        Overshoot,
        MorphIn
    }

    anchors {
        horizontalCenter: parent ? parent.horizontalCenter : undefined
        bottom: parent ? parent.bottom : undefined
        bottomMargin: elevationValue
    }

    transform: Translate {
        y: root.translateY
    }

    radius: root.rounding
    transformOrigin: Item.Bottom
    width: animationStyle === BeamBg.Style.MorphIn ? morphWidth : implicitWidth

    states: [
        State {
            name: "hidden"
            when: !root.reveal
            PropertyChanges {
                target: root
                opacity: 0
                scale: root._noScale ? 1 : 0
                translateY: root._hiddenTranslateY
                morphWidth: root.implicitHeight
            }
        },
        State {
            name: "visible"
            when: root.reveal
            PropertyChanges {
                target: root
                opacity: 1
                scale: 1
                translateY: 0
                morphWidth: root.implicitWidth
            }
        }
    ]

    transitions: [
        Transition {
            to: "visible"
            ParallelAnimation {
                NumberAnimation {
                    target: root
                    property: "opacity"
                    duration: (animationStyle === BeamBg.Style.MorphIn ? 120 : 200) * root.animationScale
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: root
                    property: "translateY"
                    duration: (animationStyle === BeamBg.Style.SlideBottom ? 420 : animationStyle === BeamBg.Style.SpringPop ? 500 : animationStyle === BeamBg.Style.Overshoot ? 460 : animationStyle === BeamBg.Style.MorphIn ? 460 : 380) * root.animationScale
                    easing.type: animationStyle === BeamBg.Style.SlideBottom ? Easing.OutQuart : animationStyle === BeamBg.Style.SpringPop ? Easing.OutBack : animationStyle === BeamBg.Style.Overshoot ? Easing.OutElastic : animationStyle === BeamBg.Style.MorphIn ? Easing.OutExpo : Easing.OutExpo
                    easing.overshoot: animationStyle === BeamBg.Style.SpringPop ? 2.2 : 1.70158
                    easing.amplitude: animationStyle === BeamBg.Style.Overshoot ? 1.1 : 1.0
                    easing.period: animationStyle === BeamBg.Style.Overshoot ? 0.4 : 0.3
                }
                NumberAnimation {
                    target: root
                    property: "scale"
                    duration: root._noScale ? 0 : (animationStyle === BeamBg.Style.SpringPop ? 500 : animationStyle === BeamBg.Style.Overshoot ? 460 : 380) * root.animationScale
                    easing.type: root._noScale ? Easing.Linear : animationStyle === BeamBg.Style.SpringPop ? Easing.OutBack : animationStyle === BeamBg.Style.Overshoot ? Easing.OutElastic : Easing.OutExpo
                    easing.overshoot: animationStyle === BeamBg.Style.SpringPop ? 2.2 : 1.70158
                    easing.amplitude: animationStyle === BeamBg.Style.Overshoot ? 1.1 : 1.0
                    easing.period: animationStyle === BeamBg.Style.Overshoot ? 0.4 : 0.3
                }
                NumberAnimation {
                    target: root
                    property: "morphWidth"
                    duration: (animationStyle === BeamBg.Style.MorphIn ? 500 : 0) * root.animationScale
                    easing.type: Easing.OutExpo
                }
            }
        },
        Transition {
            to: "hidden"
            ParallelAnimation {
                NumberAnimation {
                    target: root
                    property: "morphWidth"
                    duration: (animationStyle === BeamBg.Style.MorphIn ? 280 : 0) * root.animationScale
                    easing.type: Easing.InExpo
                }
                NumberAnimation {
                    target: root
                    property: "opacity"
                    duration: (animationStyle === BeamBg.Style.MorphIn ? 250 : 150) * root.animationScale
                    easing.type: Easing.InCubic
                }
                NumberAnimation {
                    target: root
                    property: "translateY"
                    duration: (animationStyle === BeamBg.Style.SlideBottom ? 320 : animationStyle === BeamBg.Style.SpringPop ? 280 : animationStyle === BeamBg.Style.Overshoot ? 300 : animationStyle === BeamBg.Style.MorphIn ? 280 : 260) * root.animationScale
                    easing.type: animationStyle === BeamBg.Style.SlideBottom ? Easing.InQuart : animationStyle === BeamBg.Style.SpringPop ? Easing.InBack : animationStyle === BeamBg.Style.MorphIn ? Easing.InExpo : Easing.InExpo
                    easing.overshoot: animationStyle === BeamBg.Style.SpringPop ? 1.5 : 1.70158
                }
                NumberAnimation {
                    target: root
                    property: "scale"
                    duration: root._noScale ? 0 : (animationStyle === BeamBg.Style.SpringPop ? 280 : animationStyle === BeamBg.Style.Overshoot ? 300 : 260) * root.animationScale
                    easing.type: root._noScale ? Easing.Linear : animationStyle === BeamBg.Style.SpringPop ? Easing.InBack : Easing.InExpo
                    easing.overshoot: animationStyle === BeamBg.Style.SpringPop ? 1.5 : 1.70158
                }
            }
        }
    ]
}
