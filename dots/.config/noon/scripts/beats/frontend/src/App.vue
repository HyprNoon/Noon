<template>
  <div id="app-root" :class="{ welcome: isWelcome }">
    <div
      class="global-bg"
      :class="{ active: !!coverUrl }"
      :style="{ backgroundImage: coverUrl ? `url(${coverUrl})` : 'none' }"
    ></div>
    <Sidebar />
    <BottomNav />
    <main id="main">
      <router-view />
    </main>
  </div>
  <div id="toast" :class="{ show: toastMsg }" v-text="toastMsg || ''"></div>
</template>

<script setup>
import { computed, ref, provide, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useMpd } from './composables/useMpd.js'
import { useTheme } from './composables/useTheme.js'
import Sidebar from './components/Sidebar.vue'
import BottomNav from './components/BottomNav.vue'

const router = useRouter()
const route = useRoute()
const mpd = useMpd()
useTheme()

const toastMsg = ref('')
let toastTimer = null
function toast(msg) {
  toastMsg.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastMsg.value = '' }, 2500)
}

const isWelcome = computed(() => route.name === 'welcome')

const activePlayerCount = ref(1)
provide('activePlayerCount', activePlayerCount)

const coverUrl = computed(() =>
  mpd.currentSong.value?.file ? mpd.coverUrl(mpd.currentSong.value.file) : ''
)

async function fetchPlayers() {
  try {
    const resp = await fetch('/api/players')
    if (resp.ok) {
      const data = await resp.json()
      activePlayerCount.value = Object.values(data).filter(p => p.running).length
    }
  } catch (_) {}
}

mpd.onConnected = () => {
  toast('Connected to ' + mpd.player)
  fetchPlayers()
  router.push('/player')
}

mpd.onDisconnected = () => {
  toast('Disconnected')
  router.push('/welcome')
}

onMounted(() => {
  const restored = mpd.restore()
  if (!restored) {
    fetchPlayers()
  }
})
</script>

<style>
#app-root {
  display: flex;
  height: 100vh;
  width: 100%;
  position: relative;
}
#app-root.welcome #sidebar,
#app-root.welcome #bottom-nav { display: none; }
#app-root.welcome #main {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.global-bg {
  position: fixed;
  top: -10%;
  left: -10%;
  right: -10%;
  bottom: -10%;
  background-size: cover;
  background-position: center;
  filter: blur(50px) saturate(120%);
  opacity: 0;
  z-index: 0;
  pointer-events: none;
  transition: opacity 0.8s ease;
}

.global-bg.active {
  opacity: 0.15;
}

#sidebar { position: relative; z-index: 1; }

#main {
  flex: 1;
  overflow-y: auto;
  padding: 32px 40px;
  position: relative;
  z-index: 1;
}
#main::-webkit-scrollbar { width: 6px; }
#main::-webkit-scrollbar-track { background: transparent; }
#main::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }

@media (max-width: 768px) {
  #main {
    padding: 16px 16px max(80px, calc(env(safe-area-inset-bottom) + 64px));
  }
}
</style>
