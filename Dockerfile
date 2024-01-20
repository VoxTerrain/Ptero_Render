# Utilizăm o imagine de bază cu PHP și Apache
FROM php:7.4-apache

# Instalăm dependințele necesare
RUN apt-get update && \
    apt-get install -y --no-install-recommends git unzip && \
    rm -rf /var/lib/apt/lists/*

# Descărcăm și instalăm PufferPanel
RUN git clone --branch 2.2.1 --depth 1 https://github.com/PufferPanel/PufferPanel.git /var/www/html

# Instalăm composer și depășim verificarea SSL pentru a evita erori
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer -- --version=1.10.22 --no-plugins --no-scripts --no-suggest --no-interaction

# Instalăm dependințele PufferPanel
WORKDIR /var/www/html
RUN composer install --no-dev --prefer-dist --optimize-autoloader

# Copiem configurația și setările PufferPanel
COPY config /var/www/html/config
COPY .env /var/www/html/.env

# Setăm permisiunile corecte
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap

# Adaugăm un cont de administrator (înlocuiește "admin" și "password" cu valorile dorite)
RUN php artisan pufferpanel:install --admin=admin --email=admin@example.com --password=password

# Expunem portul 80
EXPOSE 80

# Comanda de start a container-ului
CMD ["apache2-foreground"]
