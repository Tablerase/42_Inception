#!/bin/bash

# Adminer setup
wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/adminer.php 
chown -R www-data:www-data /var/www/html/adminer.php 
chmod 755 /var/www/html/adminer.php
## Add custom css
wget "https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css" -O /var/www/html/adminer.css
chown -R www-data:www-data /var/www/html/adminer.css

# Custome config
## Stop the apache server (to avoid conflict)
service apache2 stop
## Add adminer as the default page (redirect to adminer.php)
echo "<?php header('Location: /adminer.php'); ?>" > /var/www/html/index.php

# Launch the php server
## Go to the html folder
cd /var/www/html
## Remove the default index.html file (to avoid launching the default page instead of index.php)
rm -rf index.html
## Start the server
php -S 0.0.0.0:80