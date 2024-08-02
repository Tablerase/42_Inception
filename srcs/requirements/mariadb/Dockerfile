#Base Image
FROM debian:11-slim

# Install Packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \ 
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Setup Config
## Config file for mariadb
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

## Script to setup mariadb
COPY ./tools/mariadb_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb_setup.sh

# Set entrypoint script
ENTRYPOINT ["mariadb_setup.sh"]
## Arg can be pass below for the entrypoint
CMD ["mysqld"]
