# 1) go to temp directory
cd /tmp

# 2) move local plugins to plugin directory
#    loop through plugins folder for directories; move directories to plugin folder
for plugin in echo plugin-files/*
do 
    [ -d "${plugin}" ] || continue # if it's not a directory, skip
    echo "moving $plugin to plugins directory"
    mv $plugin /var/www/html/wp-content/plugins
done

# 3) import plugin names from plugins.list to variable
plugins_list=`cat plugin-files/plugins.list`

# 4) move to site directory
cd /var/www/html

# 5) install remote plugins
wp plugin install $plugins_list --allow-root

# 6) loop thru and activate all plugins
#    move to plugins directory
cd /var/www/html/wp-content/plugins
#    loop through all plugins and activate
plugins_list=`echo *`
wp plugin activate $plugins_list --allow-root

# run the import function on the dummy content
echo 'importing content...'
wp import /tmp/wp-template.xml --authors=create --allow-root