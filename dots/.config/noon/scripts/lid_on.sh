#!/bin/bash
if grep -q open /proc/acpi/button/lid/LID/state; then
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
fi
