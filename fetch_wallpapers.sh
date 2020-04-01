#!/bin/bash

# Available categories:
# All
# 3D
# 60 Favorites
# Abstract
# Animals
# Anime
# Art
# Black
# Cars
# City
# Dark
# Fantasy
# Flowers
# Food
# Holidays
# Love
# Macro
# Minimalism
# Motorcycles
# Music
# Nature
# Other
# Smilies
# Space
# Sport
# Technologies
# Textures
# Vector
# Words

USAGE="Usage= ./fetch_wallpaper.sh <<CATEGORY>> <<RESOLUTION>> <<PAGES>> <<DOWNLOADDIR>>"
SITE="https://wallpaperscraft.com"
CATEGORY="$1"
RESOLUTION="$2"
PAGES="$3"
DOWNLOADDIR="$4"
if [[ -z "$CATEGORY" || -z "$RESOLUTION" || -z "$PAGES" || -z "$DOWNLOADDIR" ]]; then echo $USAGE ; exit

else
    if [ "$PAGES" -gt 1 ]; then

        for x in `seq 1 $PAGES` ; do curl -s $SITE/catalog/$CATEGORY/page$x/ | grep "wallpapers__link"  | awk -F'"' '{print $4"/'$RESOLUTION'/"}'  | sed 's/wallpaper/download/g'  | awk '{print "'$SITE'" $0}' | xargs curl -s | grep Download | grep href | awk -F'"' '{print $4}' | xargs wget -nc -P $DOWNLOADDIR; done

    else

        curl -s $SITE/catalog/$CATEGORY/page1/ | grep "wallpapers__link"  | awk -F'"' '{print $4"/'$RESOLUTION'/"}'  | sed 's/wallpaper/download/g'  | awk '{print "'$SITE'" $0}' | xargs curl -s | grep Download | grep href | awk -F'"' '{print $4}' | xargs wget -nc -P $DOWNLOADDIR
    fi
fi
