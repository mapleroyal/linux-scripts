#!/bin/bash

# Path to your interactive wallpaper script
wallpaper_script_path="~/repos/linux-scripts/wallpaper-gnome-1200p.sh"

# Launch the interactive wallpaper script in a new kgx terminal
kitty sh -c "$wallpaper_script_path; read -n1 -p 'Press any key to exit...'"