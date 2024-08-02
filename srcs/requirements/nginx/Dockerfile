# Base Image
FROM debian:11-slim

# Install packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  nginx \
  openssl \
  curl \
  vim \
  && rm -rf /var/lib/apt/lists/*

# Setup Config
## nginx
RUN rm -rf /etc/nginx/nginx.conf
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

## ssl certificate
RUN mkdir -p /etc/nginx/ssl
### Get arguments from docker-compose.yml
ARG SSL_COUNTRY
ARG SSL_STATE
ARG SSL_LOCATION
ARG SSL_ORGANIZATION
ARG SSL_ORGANIZATION_UNIT
ARG SSL_COMMON_NAME
### Generate SSL certificate
RUN openssl req \
  -x509 \
  -nodes \
  -out /etc/nginx/ssl/inception.crt \
  -keyout /etc/nginx/ssl/inception.key \
  -subj "/C=${SSL_COUNTRY}/ST=${SSL_STATE}/L=${SSL_LOCATION}/O=${SSL_ORGANIZATION}/OU=${SSL_ORGANIZATION_UNIT}/CN=${SSL_COMMON_NAME}"

# Change permission
## Allow server to read/write in web dir
RUN chown -R www-data:www-data /var/www/html

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
# -g daemon off;
# run nginx in foreground mode to allow docker to manage the process and not exit immediately
