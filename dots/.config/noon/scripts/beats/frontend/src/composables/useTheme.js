import { ref, watch } from 'vue'

const theme = ref(localStorage.getItem('beats-theme') || 'system')

function apply(mode) {
  const html = document.documentElement
  if (mode === 'light') html.dataset.theme = 'light'
  else if (mode === 'dark') html.dataset.theme = 'dark'
  else html.removeAttribute('data-theme')
}

apply(theme.value)

watch(theme, (val) => {
  localStorage.setItem('beats-theme', val)
  apply(val)
})

export function useTheme() {
  function setTheme(mode) { theme.value = mode }
  return { theme, setTheme }
}
