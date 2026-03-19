#!/bin/bash

# 1. Define the command without spaces around '='
# Use a custom name like 'MY_SHELL' to avoid messing with system defaults
MY_SHELL="qs -c $HOME/.config/noon"

# 2. Kill the processes
# Note: 'killall' might fail if the process isn't running,
# so we use 'pkill' or ignore errors to keep the script moving.
killall ydotool
killall quickshell
killall qs

# 3. Execute the new shell
# Using 'nohup' or '&' ensures it keeps running after this script closes
eval "$MY_SHELL" &
