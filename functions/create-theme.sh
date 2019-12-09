#!/bin/bash

echo 'now creating wordpress theme'

# 0) delete git folder just in case
#    uses -f flag to avoid prompts
echo 'cleaning git files...'
rm -rf .git

# 1) download the git package from gitlab
#    saves the files into a subdirectory: wordpress templates
#    also deletes the related git files, for the original repository's safety
echo 'downloading theme files...'
# TODO: correct repo
git clone 
rm -rf wordpress-templates/.git

# 2) install dependencies
echo 'installing dependencies...'
npm install

# 3) delete package.json, as its no longer needed
rm package.json package-lock.json

# 4) run the create-theme script
#    first reads the theme name and IP from file, then calls the script with these as args
theme_name=`cat data/local/project-name`
IP=`cat data/local/IP`
theme_name_snake=`echo "${theme_name// /_}" | tr '[:upper:]' '[:lower:]'`

node wordpress-templates/build-theme.js $theme_name_snake $IP

# 5) move theme-files/theme-parts into del folder
echo 'cleaning up...'
mkdir del
mv wordpress-templates/theme-parts del/theme-parts
mv wordpress-templates/build-theme.js del/build-theme.js

# 6) clear out node_modules, as thye're no longer used, and will be replaced with the 
#    compiler scripts later anyways
rm -rf node_modules