#!/bin/zsh

# Function to reset terminal settings on exit
function on_exit() {
    stty "$original_stty_settings"
}

# Save original terminal settings and trap exit signal
original_stty_settings=$(stty -g)
trap on_exit EXIT

# Set terminal to read input immediately
stty -icanon -echo min 1 time 0

# Begin main script
while true; do
    echo "Choose an option:"
    echo "1 - Apply a random wallpaper"
    echo "2 - Modify the current wallpaper"
    echo "q - Quit"
    
    option=$(dd bs=1 count=1 2>/dev/null)
    
    if [[ $option == "q" ]]; then
        break
    fi
    
    if [[ $option == "1" ]]; then
        selected_file=$(find /home/$USER/Pictures/wallpapers \( -path "/home/$USER/Pictures/wallpapers/dark/*" -o -path "/home/$USER/Pictures/wallpapers/light/*" \) -type f | shuf -n 1)
        /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$selected_file"
        elif [[ $option == "2" ]]; then
        # get current wallpaper path
        current_bg=$( /usr/bin/gsettings get org.gnome.desktop.background picture-uri-dark | tr -d "'" )
        
        while true; do
            echo "Choose an option:"
            echo "1 - Add rounded corners"
            echo "2 - Darken the image"
            echo "3 - Both"
            echo "q - Quit"
            
            mod_option=$(dd bs=1 count=1 2>/dev/null)
            
            if [[ $mod_option == "q" ]]; then
                exit
            fi
            
            rounded_corners="/home/$USER/Pictures/wallpapers/roundedcorners.png"
            
            # get current wallpaper path
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
        done
    else
        echo "Invalid input. Please try again."
    fi
done