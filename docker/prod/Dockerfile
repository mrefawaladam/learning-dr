FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    zip unzip git curl \
    libpng-dev libonig-dev libxml2-dev \
 && docker-php-ext-install pdo pdo_mysql mbstring bcmath gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY src/ .

RUN composer install --no-dev --optimize-autoloader \
 && chown -R www-data:www-data /var/www \
 && chmod -R 775 storage bootstrap/cache

USER www-data
