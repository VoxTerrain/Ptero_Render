# Use a base image with necessary dependencies
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl zip unzip tar git && \
    rm -rf /var/lib/apt/lists/*

# Install Docker
# Note: This is just an example, and the actual process may vary depending on your environment
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

# Install Pterodactyl dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install --no-install-recommends \
    software-properties-common \
    ca-certificates \
    curl \
    git \
    unzip \
    tar \
    nginx \
    mysql-client \
    php-cli \
    php-fpm \
    php-json \
    php-mbstring \
    php-pdo \
    php-mysql \
    php-tokenizer \
    php-bcmath \
    php-xml \
    php-curl \
    php-zip \
    && rm -rf /var/lib/apt/lists/*
    RUN mkdir -p /run/php
RUN chown -R www-data:www-data /run/php
# Install Pterodactyl Panel
# Note: This is just an example, and the actual process may vary depending on the Pterodactyl version
RUN curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar --strip-components=1 -xzv
listen = /run/php/php7.4-fpm.sock
# Configure Pterodactyl Panel
# Note: Configuration steps depend on your specific requirements

# Expose ports
EXPOSE 80

# Start Pterodactyl Panel
CMD ["/usr/sbin/php-fpm7.4", "-F", "--fpm-config", "/etc/php/7.4/fpm/php-fpm.conf"]

