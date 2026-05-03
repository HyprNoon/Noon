#!/usr/bin/env bash
sleep 0.2
CURRENT=$(sed -n 's/^ColorScheme=\(.*\)/\1/p' ~/.config/kdeglobals)
[[ "$CURRENT" == *2 ]] && TARGET="Noon" || TARGET="Noon2"
plasma-apply-colorscheme "$TARGET"
