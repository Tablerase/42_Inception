# Base
FROM debian:11-slim

# Install Packages

## Update and Upgrade => Install curl and vim
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    wget php php-mysql \
  && rm -rf /var/lib/apt/lists/*

# Configuration

## Add Setup Script
COPY tools/adminer_setup.sh /tmp/adminer_setup.sh
RUN chmod +x /tmp/adminer_setup.sh

# Launch
ENTRYPOINT [ "/tmp/adminer_setup.sh" ]