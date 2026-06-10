#!/bin/bash

killall -9 ydotool
killall -9 quickshell
killall -9 qs

eval "qs -c $HOME/.config/noon" 2>/dev/null
