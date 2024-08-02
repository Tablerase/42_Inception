#!/bin/bash

# Create a FTP server
## Create a new group
groupadd ftpgroup

# Create ftp user
## -d: home directory
## -s: shell => /bin/false => no shell access
## -g: group
## -G: additional groups
## -c: comment
useradd -d /var/www/html -s /bin/false -g www-data -G ftpgroup -c "FTP User" $FTP_USER
## Set password
ftp_pass=$(cat $FTP_PASSWORD_FILE)
echo "$FTP_USER:$ftp_pass" | chpasswd

# Lauch the ftp server
## Log as the user proftpd
su proftpd
## -nodaemon: run in the foreground
proftpd --nodaemon