import QtQuick
import qs.common
import qs.common.functions

ConfigFileView {
    id: root
    readonly property string basePath: Directories.standard.state + "/plugins/"
    readonly property string cleanPath: FileUtils.trimFileProtocol(path)
    path: basePath + fileName + ".json"
}
