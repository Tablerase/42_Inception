#!/bin/bash

# Get password from secret file
mysql_password=$(cat $MYSQL_PASSWORD_FILE)
mysql_root_password=$(cat $MYSQL_ROOT_PASSWORD_FILE)
mysql_grafana_password=$(cat $MYSQL_GRAFANA_PASSWORD_FILE)

# MariaDB configuration

# Config the database
## Start the service
service mariadb start

## Wait for the service to start
timeout=30
while [ ! -e /run/mysqld/mysqld.sock ]; do
	timeout=$(($timeout - 1))
	if [ $timeout -eq 0 ]; then
		echo "Failed to start MariaDB"
		exit 1
	fi
	sleep 1
done

# Create Database
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" > /tmp/database.sql
## Create user with access from localhost
echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$mysql_password';" >> /tmp/database.sql
## Give elevated privileges to created user for all the tables in the database (%: mean can connect form any host: localhost and other address)
echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$mysql_password';" >> /tmp/database.sql

# [Grafana]
## Add a grafana user
echo "CREATE USER IF NOT EXISTS '$MYSQL_GRAFANA_USER'@'localhost' IDENTIFIED BY '$mysql_grafana_password';" >> /tmp/database.sql
## Give elevated privileges to created user for read access to the database (%: mean can connect form any host: localhost and other address)
echo "GRANT SELECT ON $MYSQL_DATABASE.* TO '$MYSQL_GRAFANA_USER'@'%' IDENTIFIED BY '$mysql_grafana_password';" >> /tmp/database.sql

## Protect root connection via localhost
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$mysql_root_password';" >> /tmp/database.sql
## Load changes into database
echo "FLUSH PRIVILEGES;" >> /tmp/database.sql
## Load changes into database
mysql < /tmp/database.sql
## Remove the file
rm -f /tmp/database.sql

# Launch in recommended: safety mode (with auto restart in case of error and more safety features)
## Stop MYSQL server
kill $(cat /var/run/mysqld/mysqld.pid)
## Restart with CMD command
exec $@