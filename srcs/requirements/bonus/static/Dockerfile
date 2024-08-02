# Base model
FROM debian:11-slim

# Install Packages

## Update and Upgrade => Install curl and vim
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Setup the Environment

## Create a work directory for the web site
WORKDIR /usr/src/app
### Copy files from the host to the container
COPY ./app /usr/src/app

## Create a non-root user
RUN useradd -m node
### Change the owner of the work directory
RUN chown -R node /usr/src/app
### Change the user to the non-root user
USER node

# Setup Web Site

## Install nvm and node
### Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
### Install node 20 (LTS) with nvm (source nvm.sh - prevent nvm command not found)
RUN /bin/bash -c "source ~/.nvm/nvm.sh && nvm install 20"
### Install app dependencies
RUN /bin/bash -c "source ~/.nvm/nvm.sh && npm -v"
#### --omit=dev to avoid installing dev dependencies
RUN /bin/bash -c "source ~/.nvm/nvm.sh && npm install --omit=dev"

# Run the app

CMD ["/bin/bash", "-c", "source ~/.nvm/nvm.sh && npm start"]