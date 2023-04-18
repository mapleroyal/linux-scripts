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




apply a random wallpaper
find /home/user1/Pictures/wallpapers/light -type f -print0 | shuf -zn1 | xargs -0 realpath

apply a specific wallpaper
	add rounded corners?
		if yes
			add dimming?
				if yes
					add both > output > apply
				if no
					only round > output > apply
		if no
			add dimming?
				if yes
					only dim > output apply
				if no
					apply image straight away