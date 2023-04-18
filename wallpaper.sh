#!/bin/zsh

if [ -e /home/$USER/scripts/monitor-res ]; then
    # Read monitor resolution from file
    resolution=$(tail -n 1 /home/$USER/scripts/monitor-res)
else
    # File doesn't exist, prompt user for input
    while true; do
        echo "Enter your monitor resolution in the format 'WIDTHxHEIGHT', e.g. 1920x1080"
        read resolution
        # Add input validation
        if [[ $resolution =~ ^[0-9]+x[0-9]+$ ]]; then
            break
        else
            echo "Invalid format, please try again."
        fi
    done
    # Create file and directory if they don't exist
    mkdir -p /home/$USER/scripts
    touch /home/$USER/scripts/monitor-res
    # Save user input to file
    echo "# Monitor resolution file. On the first empty line, enter your preferred resolution." > /home/$USER/scripts/monitor-res
    echo "# Format: WIDTHxHEIGHT, e.g. 1920x1200" >> /home/$USER/scripts/monitor-res
    echo "$resolution" >> /home/$USER/scripts/monitor-res
fi

echo "Choose an option:"
echo "1 - Apply a random wallpaper"
echo "2 - Apply a specific wallpaper"

read option

if [[ $option == "1" ]]; then
    selected_file=$(find /home/$USER/Pictures/wallpapers -type f | shuf -n 1)
    /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$selected_file"
else
    echo "Enter the path to the image:"
    read image_path
    
    temp_image="/tmp/temp_wallpaper.png"
    # Use monitor resolution value in the convert command
    convert "$image_path" -resize "$resolution^" -gravity center -crop $resolution+0+0 "$temp_image"
    
    echo "Do you want to add rounded corners?"
    echo "1 - Add rounded corners"
    echo "2 - No rounded corners"
    read corners_option
    
    if [[ $corners_option == "1" ]]; then
        rounded_corners="/home/$USER/Pictures/wallpapers/roundedcorners.png"
        convert "$temp_image" "$rounded_corners" -composite "$temp_image"
    fi
    
    echo "Do you want to darken the image for nighttime use?"
    echo "1 - Darken the image"
    echo "2 - Do not darken the image"
    read dark_option
    
    mkdir -p "/home/$USER/Pictures/wallpapers/current"
    output_image="/home/$USER/Pictures/wallpapers/current/currentbg.jpg"
    if [[ $dark_option == "1" ]]; then
        convert "$temp_image" -fill black -colorize 60% "$output_image"
    else
        cp "$temp_image" "$output_image"
    fi
    
    /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$output_image"
fi