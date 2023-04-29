#!/bin/bash

# Put wallpapers in /home/$USER/Pictures/wallpapers/bg-images (or change the path below)
# roundedcorners.png is a transparent png with a rounded corners mask:
# Add it to /home/$USER/Pictures/wallpapers/roundedcorners.png (or change the path below)

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
        selected_file=$(find /home/$USER/Pictures/wallpapers/bg-images -type f | shuf -n 1)
        # Updated command to set the image
        swww img "$selected_file" -t any --transition-duration 1.5
        elif [[ $option == "2" ]]; then
        # Get current wallpaper filename
        current_bg_name=$(swww query | grep -oP 'image: "\K[^"]+')
        # Find the actual path of the image
        current_bg=$(find "/home/$USER/Pictures/wallpapers/" -type f -name "$current_bg_name" | head -n 1)
        
        # Check if the image is found and set current_bg accordingly
        if [ -z "$current_bg" ]; then
            echo "Error: Image not found."
        else
            echo "Image found at: $current_bg"
        fi
        
        
        echo "Choose modifications (type numbers without spaces and press Enter):"
        echo "1 - Add rounded corners"
        echo "2 - Darken"
        echo "3 - Blur - Max"
        echo "4 - Blur - Min"
        echo "5 - Pixelate - Max"
        echo "6 - Pixelate - Min"
        echo "q - Quit"
        
        # Reset terminal settings for modification input
        stty sane
        
        read -r mod_options
        
        # Restore terminal settings
        stty -icanon -echo min 1 time 0
        
        if [[ $mod_options == "q" ]]; then
            exit
        fi
        
        rounded_corners="/home/$USER/Pictures/wallpapers/roundedcorners.png"
        
        # create a temporary image
        temp_image="/tmp/temp_bg.png"
        cp "$current_bg" "$temp_image"
        
        # create a directory to store the modified image
        mkdir -p "/home/$USER/Pictures/wallpapers/current"
        timestamp=$(date +%Y%m%d_%H%M%S)
        output_image="/home/$USER/Pictures/wallpapers/current/currentbg_$timestamp.jpg"
        
        # Remove the oldest file in the directory, leaving only the most recent one
        find "/home/$USER/Pictures/wallpapers/current" -type f -iname "currentbg_*" -printf "%T@ %p\n" | sort -n | head -n -1 | cut -d' ' -f 2- | xargs rm -f
        
        for mod_option in $(echo $mod_options | grep -o .); do
            case $mod_option in
                1)
                    # add rounded corners
                    convert "$temp_image" -resize "1920x1200^" -gravity center -extent 1920x1200 "$temp_image"
                    convert "$temp_image" "$rounded_corners" -gravity center -composite "$temp_image"
                ;;
                2)
                    # darken the image
                    convert "$temp_image" -fill black -colorize 60% "$temp_image"
                ;;
                3)
                    # blur the image - maximum
                    convert "$temp_image" -blur 0x43 "$temp_image"
                ;;
                4)
                    # blur the image - minimum
                    convert "$temp_image" -blur 0x17 "$temp_image"
                ;;
                5)
                    # pixelate the image - maximum
                    convert "$temp_image" -resize "1920x1200^" -gravity center -extent 1920x1200 "$temp_image"
                    convert "$temp_image" -scale 5% -scale 2000% "$temp_image"
                ;;
                6)
                    # pixelate the image - minimum
                    convert "$temp_image" -resize "1920x1200^" -gravity center -extent 1920x1200 "$temp_image"
                    convert "$temp_image" -scale 10% -scale 1000% "$temp_image"
                ;;
                *)
                    echo "Invalid input. Please try again."
                ;;
            esac
        done
        
        # copy the modified image to the output location
        cp "$temp_image" "$output_image"
        
        # set wallpaper with
        swww img "$output_image" -t any --transition-duration 1.5
        
    else
        echo "Invalid input. Please try again."
    fi
    
done