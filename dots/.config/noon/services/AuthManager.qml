pragma Singleton
import QtQuick
import Quickshell
import qs.common
import qs.common.utils

Singleton {
    id: root
    readonly property var connections: {
        try {
            return JSON.parse(oauthView.text());
        } catch (e) {
            return console.log("Failed to parse OAuth : " + e);
        }
    }
    readonly property var integrations: {
        "tasks": {
            id: "tasks",
            name: "Google Tasks",
            scopes: "https://www.googleapis.com/auth/tasks",
            authId: Mem.env.NOON_TASKS_ID,
            secret: Mem.env.NOON_TASKS_SECRET,
            domain: "tasks.google.com",
            icon: "https://www.gstatic.com/images/branding/product/2x/tasks_48dp.png",
            description: "Setup and get an synchronization of your local with Google Tasks"
        },
        "calendar": {
            id: "calendar",
            name: "Google Calendar",
            scopes: "https://www.googleapis.com/auth/calendar",
            secret: Mem.env.NOON_CALENDAR_SECRET,
            authId: Mem.env.NOON_CALENDAR_ID,
            domain: "calendar.google.com",
            icon: "https://www.gstatic.com/images/branding/product/2x/calendar_48dp.png",
            description: "Setup and get your Google Calendar Events"
        }
    }
    function _cmd(...args) {
        mainProc.running = false;
        mainProc.command = ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/oauth_manager.py", ...args];
        mainProc.running = true;
    }
    function isAuth(id: string) {
        if (!id || !connections)
            return;
        return connections[id]?.access_token.length > 0;
    }
    function auth(id: string) {
        if (id && !connections[id]) {
            const d = integrations[id];
            _cmd("auth", "--id", d.authId, "--scopes", d.scopes, "--secret", d.secret, "--notify");
        }
    }
    function revoke(id: string) {
        if (id && connections[id])
            _cmd("revoke", "--id", id, "--notify");
    }
    function refresh() {
        oauthView.reload();
    }
    Process {
        id: mainProc
    }
    FileView {
        id: oauthView
        preload: true
        watchChanges: true
        path: Directories.standard.state + "/user/generated/2fa.json"
    }
}
