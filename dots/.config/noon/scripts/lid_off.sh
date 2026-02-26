#!/bin/bash
if grep -q open /proc/acpi/button/lid/LID/state; then
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
else
    if [[ $(hyprctl monitors | grep "Monitor" | wc -l) -gt 1 ]]; then
        hyprctl keyword monitor "eDP-1, disable"
    else
        systemctl suspend
    fi
fi
