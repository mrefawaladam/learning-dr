FROM php:8.2-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# copy source
COPY . .

# install dependency saat build
RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www

USER www-data
CMD ["php-fpm"]
