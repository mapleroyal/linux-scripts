#!/bin/zsh

echo "Choose an option:"
echo "1 - Apply a random wallpaper"
echo "2 - Apply a specific wallpaper"

read option

if [[ $option == "1" ]]; then
  selected_file=$(find /home/archer/Documents/wallpapers -type f | shuf -n 1)
  /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$selected_file"
else
  echo "Enter the path to the image:"
  read image_path

  temp_image="/tmp/temp_wallpaper.png"
  convert "$image_path" -resize "1920x1080^" -gravity center -crop 1920x1080+0+0 "$temp_image"

  echo "Do you want to add rounded corners?"
  echo "1 - Add rounded corners"
  echo "2 - No rounded corners"
  read corners_option

  if [[ $corners_option == "1" ]]; then
    rounded_corners="/home/archer/Documents/wallpapers/roundedcorners.png"
    convert "$temp_image" "$rounded_corners" -composite "$temp_image"
  fi

  echo "Do you want to darken the image for nighttime use?"
  echo "1 - Darken the image"
  echo "2 - Do not darken the image"
  read dark_option

  mkdir -p "/home/archer/Documents/wallpapers/current"
  output_image="/home/archer/Documents/wallpapers/current/currentbg.jpg"
  if [[ $dark_option == "1" ]]; then
    convert "$temp_image" -fill black -colorize 60% "$output_image"
  else
    cp "$temp_image" "$output_image"
  fi

  /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$output_image"
fi




# Make a script (arch, zsh, gnome) for setting wallpapers. Here are some details about the script:

# When applying a wallpaper, use this command:
# /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark /path/to/image

# Start by prompting the user to choose:
# 1 - Apply a random wallpaper
# 2 - Apply a specific wallpaper

# If they press 1 (no need to press enter):
# 	Choose a random file from /home/archer/Documents/wallpapers and its subdirectories, then use the command above to apply the wallpaper.

# Otherwise, if they choose to apply a specific wallpaper by pressing 2:
# 	Prompt them for the path to the image.
# 	When they enter the path and press enter, use imagemagick to crop it to 16:10 ratio and save the output to a temporary location. Then, prompt them asking if they want to apply rounded corners.
# 		1 - add rouned corners
# 		2 - no rounded corners
		
# If they choose to add rounded corners by pressing 1, use imagemagick to layer /path/to/roundedcorners.png on top of the temporary image, and store the new output by replacing the temporary input (in other words, take in the temp image, layer the rounded corners, and update the temp image with the changes). roundedcorners.png is a png file that's primarily completely transparent except for black on the corners that give the illusion of having a monitor with rounded corners when it's used over a wallpaper image.

# Then, prompt them asking if they want to darken the image for nighttime use:
# 	1 - darken the image for nighttime use
# 	2 - do not darken the image

# If they choose to darken the image by pressing 1, use imagemagic to add a black layer (60% opacity) on top of the updated temp image, then output the final result (the base image with rounded corners and the darkening effect) to /home/archer/Documents/wallpapers/current/currentbg.jpg, and apply it as the wallpaper.

# Otherwise, if they choose not to darken the image, then output the final result (the base image with rounded corners) to /home/archer/Documents/wallpapers/current/currentbg.jpg, and apply it as the wallpaper.

# Suppose that earlier they chose not to add rounded corners by pressing 2, then prompt them asking if they want to darken the image for nighttime use:
# 	1 - darken the image for nighttime use
# 	2 - do not darken the image

# If they choose to darken the image by pressing 1, use imagemagic to add a black layer (60% opacity) on top of the updated temp image, then output the final result (the base image without rounded corners and with the darkening effect) to /home/archer/Documents/wallpapers/current/currentbg.jpg, and apply it as the wallpaper.

# Otherwise, if they choose not to add the darkening effect, then output the final result (the base image with no rounded corners and no darkening effect) to /home/archer/Documents/wallpapers/current/currentbg.jpg, and apply it as the wallpaper.

# ---

# Respond with a short pseudocode description of the logic you plan to use. Then, generate the script.

# apply a specific wallpaper
# 	add rounded corners?
# 		if yes
# 			add dimming?
# 				if yes
# 					add both > output > apply
# 				if no
# 					only round > output > apply
# 		if no
# 			add dimming?
# 				if yes
# 					only dim > output apply
# 				if no
# 					apply image straight away