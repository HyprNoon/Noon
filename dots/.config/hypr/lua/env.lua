local envs = {
    -- Existing Nvidia/Wayland Envs
    __NV_PRIME_RENDER_OFFLOAD = "0",
    __GLX_VENDOR_LIBRARY_NAME = "nvidia",
    WLR_DRM_NO_ATOMIC = "1",
    MOZ_ENABLE_WAYLAND = "1",
    LIBVA_DRIVER_NAME = "nvidia",
    NVD_BACKEND = "direct",
    AQ_FORCE_LINEAR_BLIT = "1",
    AQ_DRM_DEVICES = "/dev/dri/nvidia-dgpu:/dev/dri/intel-igpu",
    UV_WORKING_DIR = "/home/pharmaracist/.local/state/noon/",

    -- KDE
    XDG_MENU_PREFIX = "arch- kbuildsycoca6",
    PLASMA_USE_QT_SCALING = "1",
    KDE_FULL_SESSION = "true",

    -- Qt & Electron
    ELECTRON_OZONE_PLATFORM_HINT = "auto",
    QT_QPA_PLATFORM = "wayland;xcb",
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
    QT_QPA_PLATFORMTHEME = "kde",

    -- Virtual Environment / Paths
    HYPRCURSOR_THEME = "$cursor_theme",
    HYPRCURSOR_SIZE = "$cursor_size",
    FILE_MANAGER = "$file_manager",
    EDITOR = "$editor",
    SHELL_EXECUTABLE = "qs -c $HOME/.config/noon",
    SHELL_PATH = "$HOME/.config/noon",
    SHELL_CONFIG_PATH = "$HOME/.config/HyprNoon",
    SHELL_CONFIG_FILE = "$HOME/.config/HyprNoon/options.json",
    TERMINAL = "$terminal",
    BROWSER = "$browser",
    XDG_CURRENT_DESKTOP = "GNOME"
}

for k, v in pairs(envs) do
    hl.env(k, v)
end
