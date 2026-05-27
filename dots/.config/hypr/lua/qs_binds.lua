--#!
--##! Noon
hl.bind(mainMod .. "+Super_L", hl.dsp.exec_cmd(ipc .. " noon toggle_beam"), { locked = true })
hl.bind(mainMod .. "+Tab", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'View'"))
hl.bind(mainMod .. "+L", hl.dsp.exec_cmd(ipc .. " global lock"))
hl.bind(mainMod .. "+SHIFT+R", hl.dsp.exec_cmd(ipc .. " global pick_random_wall"))
hl.bind(mainMod .. "+CTRL+Period", hl.dsp.exec_cmd("wl-paste -p | xargs -0 " .. ipc .. " noon translate"))
hl.bind(mainMod .. "+CTRL+X", hl.dsp.exec_cmd(ipc .. " noon toggle_bar_mode"))
hl.bind(mainMod .. "+ALT+X", hl.dsp.exec_cmd(ipc .. " noon swap_bar_position"))
hl.bind(mainMod .. "+ALT+D", hl.dsp.exec_cmd(ipc .. " global toggle_dormant_state"))
hl.bind("CTRL+ALT+P", hl.dsp.exec_cmd(ipc .. " noon toggle_dock_pin"))

--##! XP
hl.bind(mainMod .. "+R", hl.dsp.exec_cmd(ipc .. " xp toggle_run"), { non_consuming = true })
hl.bind(mainMod .. "+Super_L", hl.dsp.exec_cmd(ipc .. " xp toggle_start_menu"), { locked = true })

--##! Nobuntu
hl.bind(mainMod .. "+Super_L", hl.dsp.exec_cmd(ipc .. " nobuntu toggle_overview"), { locked = true })
hl.bind(mainMod .. "+N", hl.dsp.exec_cmd(ipc .. " nobuntu toggle_notifs"), { locked = true })
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. " nobuntu toggle_db"), { locked = true })
hl.bind(mainMod .. "+V", hl.dsp.exec_cmd(ipc .. " nobuntu toggle_clipboard"), { locked = true })

--##! Media Controls
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. " global toggle_playing"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. " global previous_track || playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. " global next_track || playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. " global pause_all_players"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " global volume_up"), { locked = false })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " global volume_down"), { locked = false })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })

--##! Brightness Controls
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(ipc .. " global inc_brightness || brightnessctl set +5%"),
    { repeating = true, locked = true }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(ipc .. " global dec_brightness || brightnessctl set 5%-"),
    { repeating = true, locked = true }
)

--##! Sidebar Binds
hl.bind("CTRL+ALT+X", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Bars'"), { locked = true })
hl.bind(mainMod .. "+W", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Walls'"), { locked = true })
hl.bind(mainMod .. "+ALT+W", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Web'"), { locked = true })
hl.bind(mainMod .. "+CTRL+N", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Notes'"), { locked = true })
hl.bind(mainMod .. "+CTRL+G", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Games'"), { locked = true })
hl.bind(mainMod .. "+SHIFT+Tab", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'View'"), { locked = true })
hl.bind(mainMod .. "+J", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Downloads'"), { locked = true })
hl.bind(mainMod .. "+M", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Beats'"), { locked = true })
hl.bind(mainMod .. "+CTRL+T", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Tasks'"), { locked = true })
hl.bind(mainMod .. "+ALT+B", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Bookmarks'"), { locked = true })
hl.bind(mainMod .. "+A", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'API'"), { locked = true })
hl.bind(mainMod .. "+grave", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Sounds'"), { locked = true })
hl.bind(mainMod .. "+Escape", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Widgets'"), { locked = true })
hl.bind(mainMod .. "+Z", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Shelf'"), { locked = true })
hl.bind(mainMod .. "+SHIFT+P", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Plugins'"), { locked = true })
hl.bind(mainMod .. "+SHIFT+X", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Tweaks'"), { locked = true })
hl.bind(mainMod .. "+N", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Notifs'"), { locked = true })
hl.bind(
    mainMod .. "+Space",
    hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Apps' || pkill fuzzel || fuzzel"),
    { locked = true }
)
hl.bind(
    "CTRL+ALT+delete",
    hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Session' || pkill wlogout || wlogout -p layer-shell"),
    { locked = true }
)
hl.bind(mainMod .. "+V", hl.dsp.exec_cmd(ipc .. " sidebar reveal 'History'"), { locked = true })
hl.bind(
    mainMod .. "+SHIFT+Period",
    hl.dsp.exec_cmd(ipc .. " sidebar reveal 'Emojis' || pkill fuzzel || ~/.config/noon/scripts/emoji_service.sh copy"),
    { locked = true }
)

--##! Global
hl.bind("CTRL+" .. mainMod .. "+R", hl.dsp.exec_cmd(scriptsDir .. "/reload_shell.sh"))
-- hl.bind(mainMod .. "+SHIFT+L", hl.dsp.exec_cmd("systemctl restart sddm"))
