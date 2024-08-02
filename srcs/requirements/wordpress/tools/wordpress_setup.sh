#!/bin/bash

# PHP configuration

php_version=$(php -v | head -n 1 | awk '{print substr($2, 1, 3)}')

## Edit php-fpm configuration
### No clear_env to keep environment variables
sed -i 's/;clear_env = no/clear_env = no/' /etc/php/$php_version/fpm/pool.d/www.conf
### Change listen to 9000 (container port)
sed -i "s/listen = \/run\/php\/php$php_version-fpm.sock/listen = 9000/" /etc/php/$php_version/fpm/pool.d/www.conf
### Fix path info (security - prevent from executing php files in the wrong directory)
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/$php_version/fpm/php.ini
### Make php in foreground
sed -i 's/;daemonize = yes/daemonize = no/' /etc/php/$php_version/fpm/php-fpm.conf

# Wordpress configuration

## Install WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /usr/local/bin/
chmod +x /usr/local/bin/wp-cli.phar
mv /usr/local/bin/wp-cli.phar /usr/local/bin/wp

## Recover password from secret file
database_password=$(cat $WORDPRESS_DB_PASSWORD_FILE)
wp_admin_password=$(cat $WORDPRESS_ADMIN_USER_PASSWORD_FILE)
wp_user_password=$(cat $WORDPRESS_USER_PASSWORD_FILE)

## Download Wordpress
wp core download --path='/var/www/html/wordpress' --allow-root
cd /var/www/html/wordpress
## Set permissions for Wordpress files (www-data - allow to write)
chmod -R 774 /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress

## Check if wp-config.php exists
if [ ! -f wp-config.php ] ; then
	echo "[Creating wp-config.php]"
	## Create wp-config.php
	wp config create \
		--dbhost=$WORDPRESS_DB_HOST \
		--dbname=$WORDPRESS_DB_NAME \
		--dbuser=$WORDPRESS_DB_USER \
		--dbpass=$database_password \
		--dbprefix=wp_ \
		--allow-root
fi
## Check if Wordpress is installed
if ! wp core is-installed --allow-root ; then
	echo "[Installing Wordpress]"
	## Setup Wordpress URL,Title,PATH and Admin user
	wp core install \
		--url=$WORDPRESS_URL \
		--title=$WORDPRESS_TITLE \
		--admin_user=$WORDPRESS_ADMIN_USER \
		--admin_password=$wp_admin_password \
		--admin_email=$WORDPRESS_ADMIN_USER_EMAIL \
		--skip-email \
		--allow-root
	echo "[Creating user $WORDPRESS_USER]"
	## Add User
	wp user create \
		$WORDPRESS_USER $WORDPRESS_USER_EMAIL \
		--role=editor \
		--user_pass=$wp_user_password \
		--allow-root
fi
## Add redis cache
### Install Redis plugin
if [ ! -d /var/www/html/wordpress/wp-content/plugins/redis-cache ]; then
    wp plugin install redis-cache --activate --allow-root
    ### Set Redis configuration
    #### Set wordpress cache to true
    wp config set WP_CACHE true --raw --allow-root
    #### Define Redis Host and Port (to reach the redis service)
    wp config set WP_REDIS_HOST redis --raw --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    #### Define redis database, password and timeouts
    ##### Set cache database to redis database 0
    wp config set WP_REDIS_DATABASE 0 --raw --allow-root
    wp config set WP_REDIS_PASSWORD "" --allow-root
    wp config set WP_REDIS_TIMEOUT 1 --raw --allow-root
    wp config set WP_REDIS_READ_TIMEOUT 5 --raw --allow-root
    #### Define maxttl (time to live) to 1 hour (3600 seconds)
    wp config set WP_REDIS_MAXTTL 3600 --raw --allow-root
    ### Enable cache
    wp redis enable --allow-root
fi

# Start

php-fpm$php_version -F -R --nodaemonize