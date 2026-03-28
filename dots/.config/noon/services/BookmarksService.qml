pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.utils

Singleton {
    id: root

    property var bookmarks: Mem.states.services.bookmarks.firefoxBookmarks ?? []
    property var bookmarkTitles: bookmarks.map(b => b.title)
    property var bookmarkUrls: bookmarks.map(b => b.url)

    function faviconFor(url) {
        if (!url)
            return "";
        try {
            const domain = new URL(url).hostname;
            const path = Directories.favicons + "/" + domain + ".ico";
            faviconDownload.domain = domain;
            faviconDownload.path = path;
            faviconDownload.url = url;
            faviconDownload.running = true;
            return path;
        } catch (e) {
            return e;
        }
    }

    function openUrl(url) {
        url ? Qt.openUrlExternally(url) : null;
    }

    function searchBookmarks(query) {
        const q = (query || "").toLowerCase();
        return bookmarks.filter(b => (b.title && b.title.toLowerCase().includes(q)) || (b.url && b.url.toLowerCase().includes(q)));
    }

    Process {
        id: faviconDownload
        property string domain: ""
        property string path: ""
        property string url: ""
        running: false
        command: ["bash", "-c", `[ -f ${path} ] || curl -s 'https://www.google.com/s2/favicons?domain=${domain}&sz=32' -o '${path}' -L -H 'User-Agent: ${Mem.options.networking.userAgent ?? ""}'`]
    }
}
