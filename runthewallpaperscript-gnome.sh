#!/bin/bash

# Path to your interactive wallpaper script
wallpaper_script_path="/home/user1/scripts/wallpaper-gnome.sh"

# Launch the interactive wallpaper script in a new kgx terminal
kgx --title "Wallpaper Script" sh -c "$wallpaper_script_path; read -n1 -p 'Press any key to exit...'"