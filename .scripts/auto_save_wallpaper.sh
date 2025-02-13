#!/bin/bash

# Get the current wallpaper path from Waypaper's config file (config.ini)
wallpaper=$(grep "^wallpaper" ~/.config/waypaper/config.ini | cut -d "=" -f 2 | xargs)

# Expand the ~ to full home directory path
wallpaper=$(eval echo $wallpaper)

# Debug: Print initial wallpaper path
echo "Monitoring Waypaper config file for changes..."

# Monitor the Waypaper config file for changes
inotifywait -m ~/.config/waypaper/config.ini -e modify |
while read path action file; do
    echo "Wallpaper path changed in Waypaper config file"
    # Update the wallpaper path
    wallpaper=$(grep "^wallpaper" ~/.config/waypaper/config.ini | cut -d "=" -f 2 | xargs)
    wallpaper=$(eval echo $wallpaper)
    echo "New wallpaper path: $wallpaper"
    
    # Copy the new wallpaper to ~/.cache/current_wallpaper.jpg
    cp "$wallpaper" ~/.cache/current_wallpaper.jpg
    echo "Wallpaper updated and saved to ~/.cache/current_wallpaper.jpg"
done
