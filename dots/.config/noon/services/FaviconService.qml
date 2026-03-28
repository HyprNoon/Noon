pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.services
import qs.common.utils

Singleton {
    id: root

    property var _cache: ({})

    function get(url) {
        if (!url)
            return "";
        try {
            const domain = new URL(url).hostname;
            if (root._cache[domain])
                return root._cache[domain];
            const path = Directories.favicons + "/" + domain + ".ico";
            _downloader.createObject(root, {
                domain,
                path
            });
            root._cache[domain] = path;
            return path;
        } catch (e) {
            return e;
        }
    }

    Component {
        id: _downloader

        QtObject {
            id: comp
            property string domain: ""
            property string path: ""

            property var _proc: Process {
                running: true
                command: ["bash", "-c", `[ -f ${path} ] || curl -s 'https://www.google.com/s2/favicons?domain=${domain}&sz=32' -o '${path}' -L -H 'User-Agent: ${Mem.options.networking.userAgent ?? ""}'`]
                onExited: comp?.destroy()
            }
        }
    }
}
