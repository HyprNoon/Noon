import Quickshell.Io

Socket {
    function add(text:string){
        write(text + "\n")
    }
    function reload(){
        connected = false
        connected = true
    }
}
