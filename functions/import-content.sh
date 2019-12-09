#!/bin/bash

IP=`cat data/local/IP`

# 1) upload the wpx and plugin files to the remote /tmp directory
scp wordpress-templates/wp-template.xml root@$IP:/tmp
scp -r wordpress-templates/plugin-files root@$IP:/tmp/plugin-files

# 2) ssh in and...
# 2.1) install wp-cli
cat functions/wp-cli.sh | ssh root@$IP
# 2.2) install plugins
cat functions/install-plugins.sh | ssh root@$IP

# 3) move the xml template and plugin files to del folder
echo 'cleaning up...'
mkdir del
mv wordpress-templates/wp-template.xml del/wp-template.xml
mv wordpress-templates/plugin-files del/plugin-files 