#!/bin/bash

# Path to your interactive wallpaper script
wallpaper_script_path="/home/user1/scripts/wallpaper-swww.sh"

# Launch the interactive wallpaper script in a new Kitty terminal
kitty --title "Wallpaper Script" sh -c "$wallpaper_script_path; read -n1 -p 'Press any key to exit...'"