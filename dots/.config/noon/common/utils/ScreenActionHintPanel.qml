import QtQuick

import qs.common
import qs.common.widgets

WidgetLoader {
    id: root
    active: target && target.containsDrag
    required property var target
    property var hint: ({})

    Variants {
        model: MonitorsInfo.all

        StyledPanel {
            required property var screen
            name: "unblurred_fade_layer"
            screen: modelData
            fill: true
            _layer: "Overlay"

            mask: Region {
                item: null
            }
            ScreenActionHint {
                icon: root?.hint?.icon ?? ""
                text: root?.hint?.text ?? ""
                scale: root?.hint?.scale ?? 1
                target: root.target
                hintColor: root.hint?.color ?? Colors.colPrimaryContainer
            }
        }
    }
}
