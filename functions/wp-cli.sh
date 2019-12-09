#!/bin/sh

# move to the temp directory so files are exported there
cd /tmp

# 1) install wp-cli

# download wp cli
echo 'downloading wp-cli files...'
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# test run 
php wp-cli.phar --info

# make executible, move, re-test
echo 'making excutable...'
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp --info