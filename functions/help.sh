#!/bin/bash

echo -e "\nAvailable Commands"
echo -e "-----------------------------------------------------------------\n"

# make-droplet
echo 'make-droplet [droplet name] || -d [droplet name]'
echo '    - Creates a new digital ocean droplet under the provided name'
echo -e '      [droplet name] must be a quote-surrounded string\n'

# init
echo 'init [IP address] || -i [IP address]'
echo '    - A shorthand way to initiate the wordpress droplet'
echo '      This function will:'
echo '      1) Login to the server the first time and ask the user to'
echo '         change their password'
echo '      2) Login again to install wordpress with a LAMP stack'
echo '      3) Login one last time to ask the user to input the it'
echo '         user password'
echo -e '    - Additionally saves the IP address to file\n'

#build
echo 'build  || -b '
echo '    - Builds the theme files, git repository, wp content, etc.'
echo '      Should only be run once wordpress has been fully installed'
echo '      on the server. '
echo '      NOTE: '
echo '         this script makes use of another repository on gitlab:'
echo '         wordpress-template under the bermagrp account. any changes'
echo '         to the default theme files must be made there'