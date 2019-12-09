# create the it user and its directory
adduser it
mkdir /home/it

# add it to sudo and www-data, so it has proper permissions
usermod -aG sudo,www-data it 

# give it ownership over the site directory
chown -R it /var/www/html

# echo 'please enter it passwd'
# sudo passwd it