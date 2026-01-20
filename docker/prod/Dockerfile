FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    nginx git curl unzip libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --no-dev --optimize-autoloader

COPY docker/prod/nginx.conf /etc/nginx/nginx.conf

RUN chown -R www-data:www-data storage bootstrap/cache

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
