pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

import qs.common
import qs.common.utils
import qs.common.widgets
import qs.common.functions

Singleton {
    id: root

    readonly property list<string> cmd: ["uv", "run", Directories.scriptsDir + "/dlpHelper.py"]

    function request(info) {
        if (!info)
            return;

        let final = [...root.cmd];

        if (info.title || info.artist)
            final = final.concat(["--search", info.artist ?? "", info.title ?? ""]);
        else if (info.url)
            final = final.concat(["--url", `"${info.url}"`]);

        if (info.audio)
            final.push("--audio");
        else if (info.video)
            final.push("--video");

        if (info.quality)
            final = final.concat(["--quality", info.quality]);

        if (info.directory)
            final = final.concat(["-d", FileUtils.trimFileProtocol(info.directory)]);
        console.log(final);
        NoonUtils.execDetached(final);
    }
}
