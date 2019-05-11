#!/bin/sh
# Adds a photo to the git repository folder, ready to be pushed to github:
# copies the originals to 'original', puts a thumbnail in 'thumb', and puts
# two versions of different sizes in 'small' and 'large'.


# strip filename of extension and path
filename=${1%.*}
filename=${filename##*/}

# copy originals
cp -t original $1 $1.xmp

# make thumbnail
darktable-cli $1 $1.xmp thumb/$filename.jpg --width 300 --height 300 --hq true

# make small image
darktable-cli $1 $1.xmp small/$filename.jpg --width 800 --height 800 --hq true

# make large image
darktable-cli $1 $1.xmp large/$filename.jpg --width 1600 --height 1600 --hq true

