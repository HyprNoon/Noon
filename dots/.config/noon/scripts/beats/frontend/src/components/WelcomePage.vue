<template>
  <div id="welcome-box">
    <div class="welcome-brand">
      <span>beats</span>
      <span class="welcome-dot" :class="{ connected: mpd.connected.value }" />
    </div>
    <p class="welcome-sub">Select a player</p>

    <div v-if="loading" class="loading">Loading players…</div>

    <div v-else id="player-list">
      <div
        v-for="p in players"
        :key="p.name"
        class="player-card"
        :class="{ running: p.running, stopped: !p.running }"
        @click="doConnect(p)"
      >
        <div class="player-status">
          <span class="status-dot"></span>
        </div>
        <div class="player-body">
          <div class="player-name">{{ p.name }}</div>
          <div class="player-meta">
            <template v-if="p.hasPassword">
              <span class="icon">lock</span> password required
            </template>
            <template v-else-if="p.running">connected</template>
            <template v-else>offline</template>
          </div>
        </div>
        <div class="player-arrow">
          <span class="icon">chevron_right</span>
        </div>
      </div>
    </div>

    <div v-if="passwordPlayer" id="password-area">
      <input
        id="pw-input"
        v-model="password"
        type="password"
        placeholder="Enter password"
        @keyup.enter="submitPassword"
        ref="pwRef"
        autofocus
      />
      <div class="pw-actions">
        <button id="pw-submit" @click="submitPassword">Connect</button>
        <button class="pw-cancel" @click="passwordPlayer = null">Cancel</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { useMpd } from '../composables/useMpd.js'

const router = useRouter()
const mpd = useMpd()

const players = ref([])
const loading = ref(true)
const passwordPlayer = ref(null)
const password = ref('')
const pwRef = ref(null)

async function fetchPlayers() {
  loading.value = true
  try {
    const resp = await fetch('/api/players')
    if (resp.ok) {
      const data = await resp.json()
      players.value = Object.values(data)
      const running = players.value.filter(p => p.running)
      if (running.length === 1) {
        doConnect(running[0])
        return
      }
    }
  } catch (_) {}
  loading.value = false
}

function onConnectGo() {
  router.push('/player')
}

async function doConnect(p) {
  if (!p.running) return
  if (p.hasPassword) {
    passwordPlayer.value = p
    password.value = ''
    await nextTick()
    pwRef.value?.focus()
    return
  }
  loading.value = true
  const prev = mpd.onConnected
  mpd.onConnected = () => { prev?.(); onConnectGo() }
  mpd.connect(p.name)
}

function submitPassword() {
  const p = passwordPlayer.value
  if (!p) return
  passwordPlayer.value = null
  const prev = mpd.onConnected
  mpd.onConnected = () => { prev?.(); onConnectGo() }
  mpd.connect(p.name, password.value)
}

onMounted(fetchPlayers)
</script>

<style scoped>
#welcome-box {
  text-align: center;
  max-width: 380px;
  width: 100%;
  animation: fadeUp 500ms ease both;
}

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

.welcome-brand {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  font-family: var(--font-display);
  font-size: 48px;
  font-weight: 700;
  color: var(--text);
  letter-spacing: -1px;
  margin-bottom: 8px;
}

.welcome-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: var(--text3);
  flex-shrink: 0;
  margin-left: auto;
  transition: background var(--transition), box-shadow var(--transition);
}

.welcome-dot.connected {
  background: var(--accent);
  box-shadow: 0 0 10px var(--accent-glow);
}

.welcome-sub {
  font-size: 15px;
  color: var(--text2);
  margin-bottom: 32px;
  font-weight: 400;
}

.loading {
  color: var(--text3);
  font-size: 14px;
  text-align: center;
  padding: 40px;
}

#player-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.player-card {
  display: flex;
  align-items: center;
  gap: 14px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 16px 18px;
  cursor: pointer;
  transition: border-color var(--transition), box-shadow var(--transition), transform 150ms;
  text-align: left;
}
.player-card:hover {
  border-color: var(--accent);
  box-shadow: 0 0 0 2px var(--accent-glow);
}
.player-card:active { transform: scale(.97); }
.player-card.stopped { opacity: .5; }

.player-status { flex-shrink: 0; }

.status-dot {
  display: block;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--text3);
  transition: background var(--transition), box-shadow var(--transition);
}
.player-card.running .status-dot {
  background: var(--accent);
  box-shadow: 0 0 6px var(--accent-glow);
}

.player-body { flex: 1; min-width: 0; }
.player-name {
  font-size: 15px;
  font-weight: 600;
  color: var(--text);
  font-family: var(--font-body);
}
.player-meta { font-size: 12px; color: var(--text3); margin-top: 2px; }
.player-meta .icon { font-size: 13px; vertical-align: middle; font-variation-settings: 'FILL' 1, 'wght' 400; }

.player-arrow { color: var(--text3); flex-shrink: 0; }
.player-arrow .icon { font-size: 20px; }

#password-area {
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: center;
  margin-top: 24px;
  animation: fadeUp 300ms ease both;
}

#pw-input {
  width: 100%;
  max-width: 280px;
  padding: 12px 16px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--surface);
  color: var(--text);
  font-size: 15px;
  font-family: var(--font-body);
  outline: none;
  transition: border-color var(--transition);
}
#pw-input:focus { border-color: var(--accent); }

.pw-actions {
  display: flex;
  gap: 10px;
}

#pw-submit {
  padding: 10px 24px;
  border: none;
  border-radius: var(--radius);
  background: var(--accent);
  color: white;
  font-size: 14px;
  font-weight: 600;
  font-family: var(--font-body);
  cursor: pointer;
  transition: background var(--transition), transform 150ms;
}
#pw-submit:hover { background: var(--accent-hover); }
#pw-submit:active { transform: scale(.97); }

.pw-cancel {
  background: none;
  border: none;
  color: var(--text2);
  font-size: 13px;
  font-family: var(--font-body);
  cursor: pointer;
  padding: 10px 16px;
  transition: color 150ms;
}
.pw-cancel:hover { color: var(--text); }

@media (max-width: 480px) {
  #welcome-box { padding: 0 16px; }
  .welcome-brand { font-size: 40px; }
  .welcome-sub { margin-bottom: 28px; font-size: 14px; }
  .player-card { padding: 14px 16px; }
  .player-name { font-size: 14px; }
}
</style>
