FROM dunglas/frankenphp:1.2-php8.3

WORKDIR /app

RUN docker-php-ext-install opcache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY composer.* ./
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --classmap-authoritative \
    --no-interaction

COPY . .

RUN php artisan key:generate --force || true
RUN php artisan optimize || true

EXPOSE 80
