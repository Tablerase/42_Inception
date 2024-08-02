# Base model
FROM debian:11-slim

# Install Packages

## Update and Upgrade => Install curl and vim
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  proftpd \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Configure the FTP Server
## Stop the FTP Server
RUN service proftpd stop

## Script to setup the FTP Server
COPY tools/ftp_setup.sh /tmp/ftp_setup.sh
RUN chmod +x /tmp/ftp_setup.sh
## Copy the Configuration File
RUN rm -f /etc/proftpd/proftpd.conf
COPY conf/proftdp.conf /etc/proftpd/proftpd.conf
RUN mkdir -p /var/www/html

# Launch the FTP Server
ENTRYPOINT [ "/tmp/ftp_setup.sh" ]