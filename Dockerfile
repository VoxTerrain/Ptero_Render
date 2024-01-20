# Utilizăm o imagine de bază cu Apache și PHP
FROM php:7.4-apache

# Instalăm extensii PHP necesare pentru WordPress
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Setăm variabilele de mediu pentru WordPress
ENV WORDPRESS_DB_HOST=mysql-server \
    WORDPRESS_DB_USER=root \
    WORDPRESS_DB_PASSWORD=root \
    WORDPRESS_DB_NAME=wordpress

# Descărcăm și instalăm WordPress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm wordpress.tar.gz \
    && chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Copiem fișierul de configurare WordPress
COPY wp-config.php /var/www/html/wp-config.php

# Specificăm portul pe care Apache va asculta
EXPOSE 80

# Comanda de start a container-ului
CMD ["apache2-foreground"]
