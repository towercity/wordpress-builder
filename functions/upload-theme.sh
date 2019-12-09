#!/bin/bash

token=`cat data/global/gitlab-token`
theme_name=`cat data/local/project-name`
IP=`cat data/local/IP`
theme_name_dash=`echo "${theme_name// /-}" | tr '[:upper:]' '[:lower:]'`
theme_name_snake=`echo "${theme_name// /_}" | tr '[:upper:]' '[:lower:]'`

# 1) init the new git repository locally
echo 'Creating git repository...'
git init
git add .
git commit -m "Init new theme repository"

# 3) install npm dependencies
echo 'installing dependencies...'
npm install

# 4) run the sass compiler
npm run build

# 5) upload (selected) folders
echo 'upoading to server...'
rsync -av -e ssh \
--exclude="styles" \
--exclude="functions" \
--exclude="node_modules" \
--exclude="data" \
--exclude="del" \
--exclude="it-build" \
--exclude="style.scss" \
$PWD/ root@$IP:/var/www/html/wp-content/themes/$theme_name_snake

# 5.1) upload htaccess
echo "uploading .htaccess"
scp wordpress-templates/.htaccess root@$IP:/var/www/html

# 6) commit to git and push
git add .
git commit -m "Build theme"
git push