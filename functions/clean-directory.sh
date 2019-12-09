#!/bin/bash

echo 'cleaning directory...'

# vars
theme_name=`cat data/local/project-name`
theme_name_dash=`echo "${theme_name// /-}" | tr '[:upper:]' '[:lower:]'`

# 1) move everything extra to del
mv data del/data
mv functions del/functions
mv it-build del/it-build
mv wordpress-templates del/wordpress-templates

# 2) prompt delete
echo -e 'Delete extra files (y/n)? \c'
read del_files

# 3) do or don't delete it
if [ "$del_files" == "y" ] || [ "$del_files" == "Y" ] 
then
    rm -r del
fi

git add .
git commit -m "Clean directory"
git push

# 4) now rename the directory to the theme name
cd ../
mv wordpress-builder $theme_name_dash