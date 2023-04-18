#!/bin/zsh

echo "Choose an option:"
echo "1 - Use default image"
echo "2 - Specify a custom image"

read -k 1 option
echo

if [[ $option == "1" ]]; then
  /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark /home/user1/Pictures/wallpapers/wall2.jpg
elif [[ $option == "2" ]]; then
  echo "Enter path to custom image:"
  read path
  /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "$path"
else
  echo "Invalid option"
fi
