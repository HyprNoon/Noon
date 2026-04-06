import QtQuick
import qs.common
import qs.services
import qs.common.widgets
import qs.common.functions

Image {
    id: fgImage
    property var parentImage
    z: 99999
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    source: WallpaperService.currentFgPath
    asynchronous: true
    cache: true
    mipmap: true
    sourceSize: parentImage?.sourceSize
    x: parentImage?.x ?? 0
    y: parentImage?.y ?? 0
}
