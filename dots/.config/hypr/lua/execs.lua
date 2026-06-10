hl.on("hyprland.start", function()
	local apps = {
		ipc .. " global trigger_autostart_apps",
		"dbus-update-activation-environment --systemd --all",
		"systemctl --user import-environment QT_QPA_PLATFORMTHEME",
		"hyprsunset",
		"hyprpm reload -n",
		"noon -d -n",
		"kdeconnectd",
		"foot --server",
		"kwalletd6",
		"gnome-keyring-daemon --start --components=secrets",
		"hypridle",
		"nm-applet",
	}

	for _, cmd in ipairs(apps) do
		hl.dsp.exec_cmd(cmd)
	end
end)
