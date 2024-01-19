# Use the official Ubuntu base image
FROM ubuntu:latest

# Set non-interactive mode during the build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl unzip software-properties-common

# Install PHP
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y php7.4 php7.4-{cli,fpm,mbstring,mysql,zip,curl,gd,xml}

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Install Pterodactyl Panel
WORKDIR /var/www/html
RUN curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz && \
    tar --strip-components=1 -xzvf panel.tar.gz && \
    chmod -R 755 storage/* bootstrap/cache/

# Configure environment variables
ENV APP_ENV=production \
    APP_KEY=SomeRandomString \
    APP_DEBUG=false \
    APP_URL=https://your-panel-url.com \
    DB_CONNECTION=mysql \
    DB_HOST=your-mysql-host \
    DB_PORT=3306 \
    DB_DATABASE=your-database-name \
    DB_USERNAME=your-database-username \
    DB_PASSWORD=your-database-password \
    DB_SOCKET=/var/run/mysqld/mysqld.sock

# Install Pterodactyl dependencies and set up the database
RUN composer install --no-dev --optimize-autoloader && \
    php artisan key:generate --force && \
    php artisan p:environment:setup --force && \
    php artisan migrate --force && \
    php artisan db:seed --force

# Expose the necessary ports
EXPOSE 80

# Start the web server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
