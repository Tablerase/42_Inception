# Base model
FROM debian:11-slim

# Install Packages

## PHP-fpm (PHP fastCGI process manager), php-mysql (allow php to communicate with mysql databases)
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  wget \
  php-mysql \
  php-fpm \
  php-redis \
  mariadb-client \
  zip \
  && rm -rf /var/lib/apt/lists/*

# Config
## Script to setup wordpress and start php-fpm
COPY ./tools/wordpress_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress_setup.sh
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

## Create a directory for the socket file of php-fpm
RUN mkdir -p /run/php

# Start
ENTRYPOINT [ "wordpress_setup.sh" ]