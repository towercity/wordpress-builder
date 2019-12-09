#!/bin/sh
#
#
# This script will install and configure WordPress on
# an Ubuntu 18.04 droplet
#
# Stolen with immense gratitude from https://github.com/digitalocean/do_user_scripts/blob/master/Ubuntu-16.04/cms/wordpress.sh
# Updated for most recent LTS

# Generate root and WordPress mysql passwords
rootmysqlpass=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev | tr -dc 'a-zA-Z0-9'`;
wpmysqlpass=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev | tr -dc 'a-zA-Z0-9'`;

# Write passwords to file
echo "Root MySQL Password: $rootmysqlpass" > /root/passwords.txt;
echo "Wordpress MySQL Password: $wpmysqlpass" >> /root/passwords.txt;


# Update Ubuntu
apt-get update;
apt-get -y upgrade;

# Install Apache/MySQL
# trying 7.0 --> 7.2 for new ubuntu packages
DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 php php-mysql libapache2-mod-php7.2 php7.2-mysql php7.2-curl php7.2-zip php7.2-json php7.2-xml mysql-server mysql-client unzip wget;

# Download and uncompress WordPress
wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip;
cd /tmp/;
unzip /tmp/wordpress.zip;

# Set up database user
/usr/bin/mysqladmin -u root -h localhost create wordpress;
/usr/bin/mysqladmin -u root -h localhost password $rootmysqlpass;
/usr/bin/mysql -uroot -p$rootmysqlpass -e "CREATE USER wordpress@localhost IDENTIFIED BY '"$wpmysqlpass"'";
/usr/bin/mysql -uroot -p$rootmysqlpass -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@localhost";

# Configure WordPress
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php;
sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', 'wordpress'/g" /tmp/wordpress/wp-config.php;
sed -i "s/'DB_USER', 'username_here'/'DB_USER', 'wordpress'/g" /tmp/wordpress/wp-config.php;
sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', '$wpmysqlpass'/g" /tmp/wordpress/wp-config.php;

# Generate Random keys
for i in `seq 1 8`
do
wp_salt=$(</dev/urandom tr -dc 'a-zA-Z0-9!@#$%^&*()\-_ []{}<>~`+=,.;:/?|' | head -c 64 | sed -e 's/[\/&]/\\&/g');
sed -i "0,/put your unique phrase here/s/put your unique phrase here/$wp_salt/" /tmp/wordpress/wp-config.php;
done

# move wp install into proper directory
cp -Rf /tmp/wordpress/* /var/www/html/.;
rm -f /var/www/html/index.html;

#make this the server root
chown -Rf www-data:www-data /var/www/html;

#enable permalink editing for wp
a2enmod rewrite;
service apache2 restart;