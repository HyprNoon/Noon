-- Global Settings & Paths
scriptsDir = os.getenv("HOME") .. "/.config/noon/scripts"
shell_cmd = "qs -c " .. os.getenv("HOME") .. "/.config/noon"
ipc = shell_cmd .. " ipc call"
mainMod = "SUPER"

-- Apps
terminal = "kitty"
terminal_alt = "kitty"
browser = "firefox"
browser_alt = "firefox"
editor = "zeditor"
file_manager = "dolphin"
task_manager = terminal .. ' fish -c "btop"'
task_manager_alt = terminal .. ' fish -c "nvtop"'

-- Decoration & Layout
blur = true
unblur_apps = true
blur_size = 2
blur_passes = 4
xray = true
ignore_opacity = true
new_optimizations = true
shadows = true
shadows_power = 5
shadows_range = 30
gaps_in = 10
gaps_out = 10
gaps_special = 40
borders = 0
rounding = 19
rounding_power = 2
layers_alpha = 0.4
applications_opacity = 1
hypr_col_alpha = 50
font_main = "Google Sans Flex"
layout = "dwindle"
vertical = true
debug_overlay = false
cursor_theme = "ArcStarry-cursors"
cursor_size = 24
animation_mode = "slidevert"
direction = vertical and "vertical" or "horizontal"
-- Monitors
active_monitor = hl.get_active_monitor()
m_width = active_monitor and active_monitor.width or 1920
m_height = active_monitor and active_monitor.height or 1080



