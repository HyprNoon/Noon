-- Global Application Rule
hl.window_rule({
    name = "windowrule-1",
    match = { class = "^(.*)" },
    no_blur = unblur_apps,
    opacity = applications_opacity,
})
hl.window_rule({
    name = "browser",
    match = { class = "^(firefox*)" },
    workspace = "2",
})
hl.window_rule({
    name = "editor",
    match = { class = "^(dev.zed.Zed*)" },
    workspace = "1",
})
-- Common Floating Rules
local float_apps = {
    { class = "^(org.kde.kclock.*)",                          size = "1000 600" },
    {
        class = "^(hyprland-share-picker.*)",
        size = "500 450",
        center = true,
    },
    { class = "kcm_.*" },
    { class = ".*plasmawindowed.*" },
    { class = ".*org.kde.kdeconnect.daemon.*" },
    { class = "^(blueberry\\.py)$" },
    { class = "^(guifetch)$" },
    { class = "^(vlc)$" },
    { title = "^(satty)$",                                    size = "1280 720" },
    { class = "^(kvantummanager)$" },
    { class = "^(qt[56]ct)$" },
    { class = "^(nwg-look)$" },
    { class = "^(org.kde.ark)$" },
    { class = "^(blueman-manager)$" },
    { class = "^(nm-applet)$" },
    { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
    {
        class = "pavucontrol-qt",
        size = math.floor(m_width * 0.6) .. " 700",
        center = true,
        float = true,
    },
    {
        class = "^(nm-connection-editor)$",
        size = math.floor(m_width * 0.45) .. " 400",
        center = true,
    },
}

for _, cfg in ipairs(float_apps) do
    hl.window_rule({
        match = { class = cfg.class, title = cfg.title },
        float = true,
        size = cfg.size,
        center = cfg.center,
    })
end

-- Hidden/Offscreen utility windows
hl.window_rule({
    match = { class = "^(plasma-changeicons)$" },
    float = true,
    no_initial_focus = true,
    move = "999999 999999",
})

-- Picture-in-Picture logic (calculated move)
hl.window_rule({
    name = "pip",
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
    size = "25% 25%",
    move = math.floor(m_width * 0.73) .. " " .. math.floor(m_height * 0.72),
})

-- Specific Logic for Games/Steam
hl.window_rule({
    name = "games",
    match = { title = ".*\\.exe" },
    immediate = true,
    fullscreen_state = 2,
})

-- Layers

hl.layer_rule({
    name = "global_layers",
    match = { namespace = "noon.*" },
    xray = false,
    ignore_alpha = layers_alpha,
})
hl.layer_rule({
    name = "noanim_blurred_layer",
    blur = true,
    match = { namespace = "noon:noanim_blurred_layer" },
    no_anim = true,
})
hl.layer_rule({
    name = "blurred_layer",
    match = { namespace = "noon:blurred_layer" },
    blur = blur,
    xray = xray
})

hl.layer_rule({
    name = "unblurred_layer",
    match = { namespace = "noon:unblurred_layer" },
    blur = false,
})

hl.layer_rule({
    name = "dialog_panel",
    match = { namespace = "noon:dialog_panel" },
    blur = blur,
    xray = xray,
    ignore_alpha = 0.7,
})

hl.layer_rule({
    name = "bar",
    match = { namespace = "noon:bar" },
    xray = true,
    blur = true,
    animation = "slide"
})

hl.layer_rule({
    name = "noanim_layer",
    match = { namespace = "noon:noanim_layer" },
    animation = "none",
    blur = false
})

hl.layer_rule({
    name = "bottom_slide_layer",
    match = { namespace = "noon:bottom_slide_layer" },
    animation = "slide",
})

hl.layer_rule({
    name = "slide_layer",
    match = { namespace = "noon:slide_layer" },
    animation = "slide",
})

hl.layer_rule({
    name = "slide_dim_layer",
    match = { namespace = "noon:slide_dim_layer" },
    dim_around = true,
    animation = "slide",
})

hl.layer_rule({
    name = "blurred_fade_layer",
    match = { namespace = "noon:blurred_fade_layer" },
    animation = "fade",
    blur = true
})
hl.layer_rule({
    name = "unblurred_fade_layer",
    match = { namespace = "noon:unblurred_fade_layer" },
    animation = "fade",
    blur = false
})
hl.layer_rule({
    name = "nobuntu",
    match = { namespace = "nobuntu.*" },
    ignore_alpha = layers_alpha,
    blur = true,
    xray = true,
})
