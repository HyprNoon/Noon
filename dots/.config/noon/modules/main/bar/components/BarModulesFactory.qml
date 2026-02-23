import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.store

Repeater {
    id: root
    property bool vertical: false

    delegate: StyledLoader {
        id: loader
        required property var modelData

        asynchronous: true
        Layout.alignment: Qt.AlignHCenter
        Layout.fillHeight: true
        Layout.fillWidth: true
        source: {
            const component = (root.vertical ? BarData.contentTable[modelData] : BarData.horizontalSubstitutions[modelData]) ?? BarData.contentTable[modelData];
            return sanitizeSource("", component);
        }

        onLoaded: if (ready) {
            BarData.layoutProps.forEach(prop => {
                Layout[prop] = Qt.binding(() => item?.Layout?.[prop]);
            });

            loader.visible = Qt.binding(() => item.visible);

            if ("bar" in item)
                item.bar = barRoot;
            if ("verticalMode" in item)
                item.verticalMode = root.vertical;
            if ("vertical" in item)
                item.vertical = root.vertical;
        }
    }
}
