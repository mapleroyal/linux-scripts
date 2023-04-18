#!/bin/zsh

# Begin main script
echo "Choose an option:"
echo "1 - Apply a random wallpaper"
echo "2 - Modify the current wallpaper"
echo "q - Quit"

read option

if [[ $option == "1" ]]; then
    selected_file=$(find /home/$USER/Pictures/wallpapers -type f | shuf -n 1)
    /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$selected_file"
else
    # get current wallpaper path
    current_bg=$( /usr/bin/gsettings get org.gnome.desktop.background picture-uri-dark | tr -d "'" )
    
    echo "Choose an option:"
    echo "1 - Add rounded corners"
    echo "2 - Darken the image"
    echo "3 - Both"
    echo "q - Quit"
    
    read mod_option
    
    rounded_corners="/home/$USER/Pictures/wallpapers/roundedcorners.png"
    
    # get current wallpaper path:
    current_bg=$( /usr/bin/gsettings get org.gnome.desktop.background picture-uri-dark | tr -d "'" )
    
    # create a temporary image
    temp_image="/tmp/temp_bg.png"
    cp "$current_bg" "$temp_image"
    
    # create a directory to store the modified image
    mkdir -p "/home/$USER/Pictures/wallpapers/current"
    timestamp=$(date +%Y%m%d_%H%M%S)
    output_image="/home/$USER/Pictures/wallpapers/current/currentbg_$timestamp.jpg"
    
    # Remove the oldest file in the directory, leaving only the most recent one
    find "/home/$USER/Pictures/wallpapers/current" -type f -iname "currentbg_*" -printf "%T@ %p\n" | sort -n | head -n -1 | cut -d' ' -f 2- | xargs rm -f
    
    # options 1 or 3
    if [[ $mod_option == "1" || $mod_option == "3" ]]; then
        # add rounded corners
        convert "$temp_image" \( "$rounded_corners" -resize "$(identify -format "%wx%h" "$temp_image")" \) -gravity center -composite "$temp_image"
    fi
    
    # options 2 or 3
    if [[ $mod_option == "2" || $mod_option == "3" ]]; then
        # darken the image
        convert "$temp_image" -fill black -colorize 60% "$temp_image"
    fi
    
    # copy the modified image to the output location
    cp "$temp_image" "$output_image"
    
    # set wallpaper with
    /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$output_image"
    
fi