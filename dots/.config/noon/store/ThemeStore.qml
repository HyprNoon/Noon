pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    id: root

    // Color Palettes
    readonly property var palettes: [
        {
            "name": "Auto",
            "value": "auto",
            "icon": "brightness_auto"
        },
        {
            "name": "Ayu Dark",
            "value": "ayu_dark",
            "icon": "dark_mode"
        },
        {
            "name": "Catppuccin Latte",
            "value": "catppuccin_latte",
            "icon": "coffee"
        },
        {
            "name": "Catppuccin Mocha",
            "value": "catppuccin_mocha",
            "icon": "coffee"
        },
        {
            "name": "Cobalt2",
            "value": "cobalt2",
            "icon": "water"
        },
        {
            "name": "Dracula",
            "value": "dracula",
            "icon": "dark_mode"
        },
        {
            "name": "GitHub Dark",
            "value": "github_dark",
            "icon": "code"
        },
        {
            "name": "Gruvbox Dark",
            "value": "gruvbox_dark",
            "icon": "palette"
        },
        {
            "name": "Gruvbox Light",
            "value": "gruvbox_light",
            "icon": "palette"
        },
        {
            "name": "High Contrast Dark",
            "value": "high_contrast_dark",
            "icon": "contrast"
        },
        {
            "name": "High Contrast Light",
            "value": "high_contrast_light",
            "icon": "contrast"
        },
        {
            "name": "Material Dark",
            "value": "material_dark",
            "icon": "layers"
        },
        {
            "name": "Material Light",
            "value": "material_light",
            "icon": "layers"
        },
        {
            "name": "Monokai",
            "value": "monokai",
            "icon": "water_drop"
        },
        {
            "name": "Nord",
            "value": "nord",
            "icon": "ac_unit"
        },
        {
            "name": "Night Owl",
            "value": "night_owl",
            "icon": "dark_mode"
        },
        {
            "name": "One Dark",
            "value": "one_dark",
            "icon": "circle"
        },
        {
            "name": "Palenight",
            "value": "palen_night",
            "icon": "dark_mode"
        },
        {
            "name": "Shades of Purple",
            "value": "shades_of_purple",
            "icon": "color_lens"
        },
        {
            "name": "Solarized Dark",
            "value": "solarized_dark",
            "icon": "wb_sunny"
        },
        {
            "name": "Solarized Light",
            "value": "solarized_light",
            "icon": "wb_sunny"
        },
        {
            "name": "Synthwave84",
            "value": "synthwave84",
            "icon": "graphic_eq"
        },
        {
            "name": "Tokyo Night",
            "value": "tokyo_night",
            "icon": "dark_mode"
        }
    ]

    // Gowall
    readonly property var themes: [
        {
            "name": "Arc Dark",
            "value": "arcdark",
            "icon": "gradient"
        },
        {
            "name": "Monochromatic",
            "value": "monochromatic",
            "icon": "contrast"
        },
        {
            "name": "Catppuccin",
            "value": "catppuccin",
            "icon": "palette"
        },
        {
            "name": "Cyberpunk",
            "value": "cyberpunk",
            "icon": "computer"
        },
        {
            "name": "Dracula",
            "value": "dracula",
            "icon": "dark_mode"
        },
        {
            "name": "Everforest",
            "value": "everforest",
            "icon": "eco"
        },
        {
            "name": "GitHub Light",
            "value": "github-light",
            "icon": "dark_mode"
        },
        {
            "name": "Gruvbox",
            "value": "gruvbox",
            "icon": "texture"
        },
        {
            "name": "Kanagawa",
            "value": "kanagawa",
            "icon": "waves"
        },
        {
            "name": "Material",
            "value": "material",
            "icon": "design_services"
        },
        {
            "name": "Monokai",
            "value": "monokai",
            "icon": "contrast"
        },
        {
            "name": "Night Owl",
            "value": "night-owl",
            "icon": "nights_stay"
        },
        {
            "name": "Nord",
            "value": "nord",
            "icon": "ac_unit"
        },
        {
            "name": "Oceanic Next",
            "value": "oceanic-next",
            "icon": "water"
        },
        {
            "name": "One Dark",
            "value": "onedark",
            "icon": "circle"
        },
        {
            "name": "Rose Pine",
            "value": "rose-pine",
            "icon": "spa"
        },
        {
            "name": "Shades of Purple",
            "value": "shades-of-purple",
            "icon": "color_lens"
        },
        {
            "name": "Solarized",
            "value": "solarized",
            "icon": "wb_sunny"
        },
        {
            "name": "Srcery",
            "value": "srcery",
            "icon": "brush"
        },
        {
            "name": "Synthwave '84",
            "value": "synthwave-84",
            "icon": "graphic_eq"
        },
        {
            "name": "Tokyo Storm",
            "value": "tokyo-storm",
            "icon": "thunderstorm"
        }
    ]

    // M3 Modes
    readonly property var modes: [
        {
            "name": "Tonal Spot",
            "value": "scheme-tonal-spot",
            "icon": "palette"
        },
        {
            "name": "Neutral",
            "value": "scheme-neutral",
            "icon": "contrast"
        },
        {
            "name": "Expressive",
            "value": "scheme-expressive",
            "icon": "colorize"
        },
        {
            "name": "Fidelity",
            "value": "scheme-fidelity",
            "icon": "image"
        },
        {
            "name": "Content",
            "value": "scheme-content",
            "icon": "image"
        },
        {
            "name": "Monochrome",
            "value": "scheme-monochrome",
            "icon": "monochrome_photos"
        },
        {
            "name": "Rainbow",
            "value": "scheme-rainbow",
            "icon": "gradient"
        },
        {
            "name": "Fruit Salad",
            "value": "scheme-fruit-salad",
            "icon": "nature"
        },
        {
            "name": "Vibrant",
            "value": "scheme-vibrant",
            "icon": "palette"
        }
    ]
}
