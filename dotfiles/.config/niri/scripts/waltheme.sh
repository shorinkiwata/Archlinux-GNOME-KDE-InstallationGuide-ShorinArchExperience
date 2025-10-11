#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Pictures/wallpaper"
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

matugen image "$RANDOM_WALLPAPER"
sleep 2 
wal -n -q -i "$RANDOM_WALLPAPER"
