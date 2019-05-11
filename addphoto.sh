#!/bin/sh
# Adds a photo to the git repository folder, ready to be pushed to github:
# copies the originals to 'original', puts a thumbnail in 'thumb', and puts
# two versions of different sizes in 'small' and 'large'. Also removes EXIF
# metadata from the exported JPG files (we don't want this for analogue
# photos at least.) Also adds a photo page to the website.


# strip filename of extension and path, and append today's date
fullname=$1
filenameNoExt=${fullname%.*}
filename=${filenameNoExt##*/}
extension=${fullname##*.}
today=`date +%Y%m%d`
filename="$filename-$today"

# copy originals
cp $1 original/$filename.$extension
cp $1.xmp original/$filename.$extension.xmp

# make thumbnail
darktable-cli $1 $1.xmp thumb/$filename.jpg --width 300 --height 300 --hq true
exiftool -overwrite_original -all= thumb/$filename.jpg

# make small image
darktable-cli $1 $1.xmp small/$filename.jpg --width 800 --height 800 --hq true
exiftool -overwrite_original -all= small/$filename.jpg

# make large image
darktable-cli $1 $1.xmp large/$filename.jpg --width 1600 --height 1600 --hq true
exiftool -overwrite_original -all= large/$filename.jpg

# add md page to website
folder=~/Website/henrin/content/photography
mdfilename=$folder/$filename.md
echo "+++" > $mdfilename
echo "date = `date +%Y-%m-%d`" >> $mdfilename
echo "filename = \"$filename.jpg\"" >> $mdfilename
cat defaultmd.txt >> $mdfilename
echo "thumb = \"https://github.com/hkauhanen/photos/raw/master/thumb/$filename.jpg\"" >> $mdfilename
echo "small = \"https://github.com/hkauhanen/photos/raw/master/small/$filename.jpg\"" >> $mdfilename
echo "large = \"https://github.com/hkauhanen/photos/raw/master/large/$filename.jpg\"" >> $mdfilename
echo "+++" >> $mdfilename

# edit md page right away and place a copy in git repository
vim $mdfilename
cp $mdfilename original

# push to github
git add .
git commit -m "added photo $filename"
git push
