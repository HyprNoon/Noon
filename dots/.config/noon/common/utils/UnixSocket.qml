import Quickshell.Io

Socket {
    property string _path: ""
    function add(text: string) {
        write(text + "\n");
        flush();
    }
    function reconnect() {
        connected = false;
        connected = true;
    }
}
