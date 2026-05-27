import { reactive, ref, shallowRef } from 'vue'

const STORAGE_KEY = 'beats-player'

class MPDClient {
  ws = null
  player = null
  _password = ''
  _pending = []
  _accResp = []
  _poller = null
  _reconnectTimer = null

  connected = ref(false)
  status = reactive({})
  currentSong = shallowRef({})
  queue = ref([])

  onConnected = null
  onDisconnected = null

  connect(player, password = '') {
    if (this.ws) return
    this.player = player
    this._password = password
    localStorage.setItem(STORAGE_KEY, JSON.stringify({ player, password }))
    this.ws = new WebSocket(`ws://${location.host}/${player}`)
    this.ws.onopen = async () => {
      this.connected.value = true
      if (password) await this._send(`password ${password}`)
      this.onConnected?.()
      this._poll()
    }
    this.ws.onclose = () => {
      this.connected.value = false
      clearInterval(this._poller)
      this._poller = null
      this.onDisconnected?.()
      if (this.player) {
        this._reconnectTimer = setTimeout(() => {
          this.ws = null
          this.connect(this.player, this._password)
        }, 3000)
      }
    }
    this.ws.onmessage = (e) => this._onMsg(e.data)
  }

  restore() {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return false
    try {
      const { player, password } = JSON.parse(raw)
      if (player) {
        this.connect(player, password || '')
        return true
      }
    } catch (_) {}
    return false
  }

  disconnect() {
    clearTimeout(this._reconnectTimer)
    clearInterval(this._poller)
    this._poller = null
    if (this.ws) {
      this.ws.onclose = null
      this.ws.close()
      this.ws = null
    }
    this.connected.value = false
    this.player = null
    this._password = ''
    this.queue.value = []
    this.currentSong.value = {}
    for (const k of Object.keys(this.status)) delete this.status[k]
    localStorage.removeItem(STORAGE_KEY)
    this.onDisconnected?.()
  }

  _onMsg(raw) {
    if (raw === 'OK') {
      const cb = this._pending.shift()
      if (cb) cb(this._accResp)
      this._accResp = []
    } else if (raw.startsWith('ACK ')) {
      this._pending.shift()?.(null)
      this._accResp = []
    } else {
      this._accResp.push(raw)
    }
  }

  _send(cmd) {
    return new Promise((resolve) => {
      this._pending.push(resolve)
      this.ws.send(cmd + '\n')
    })
  }

  cmd(...args) {
    return this._send(args.join(' '))
  }

  do(cmd, ...args) {
    return this.cmd(cmd, ...args).then(() => this.refresh())
  }

  async refresh() {
    const sStat = await this.cmd('status')
    const sSong = await this.cmd('currentsong')
    if (sStat) Object.assign(this.status, this._parseKv(sStat))
    if (sSong) this.currentSong.value = this._parseKv(sSong)
    else this.currentSong.value = {}
  }

  _parseKv(lines) {
    const map = {}
    for (const l of lines) {
      const idx = l.indexOf(': ')
      if (idx > 0) map[l.slice(0, idx)] = l.slice(idx + 2)
    }
    return map
  }

  _poll() {
    this.refresh()
    this._poller = setInterval(() => this.refresh(), 3000)
  }

  coverUrl(rel) {
    return rel ? '/api/covers/' + rel : ''
  }
}

const mpd = new MPDClient()
export function useMpd() {
  return mpd
}
