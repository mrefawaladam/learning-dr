# ----------------------------------
# Stage 1: Build Dependencies
# ----------------------------------
FROM composer:lts as deps

WORKDIR /app

# Copy hanya file composer dulu agar cache optimal
COPY composer.json composer.lock ./

# Install dependensi (no scripts agar tidak error jika class belum ada)
# PENTING: Kita butuh Octane untuk FrankenPHP mode worker.
RUN composer require laravel/octane --no-interaction --no-scripts
RUN composer install --no-dev --no-interaction --prefer-dist --ignore-platform-reqs --no-scripts

# ----------------------------------
# Stage 2: Final Runtime
# ----------------------------------
FROM dunglas/frankenphp:1-php8.3

# Install ekstensi PHP (tambahkan 'zip' dan 'intl' jika composer butuh)
RUN install-php-extensions \
    pcntl \
    pdo_mysql \
    gd \
    intl \
    zip \
    opcache

# Copy binary composer dari stage builder (Solusi 'composer not found')
COPY --from=deps /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy file aplikasi ke dalam container
COPY . .

# Copy vendor yang sudah diinstall di stage 1
COPY --from=deps /app/vendor /app/vendor
# PENTING: Copy juga composer.json/lock yang sudah dimodifikasi (ada Octane) dari stage 1
# agar sinkron dengan folder vendor.
COPY --from=deps /app/composer.json /app/composer.json
COPY --from=deps /app/composer.lock /app/composer.lock

# Re-dump autoload untuk memastikan classmap benar (no-scripts agar tidak trigger artisan)
RUN composer dump-autoload --optimize --no-dev --classmap-authoritative --no-scripts

ENV FRANKENPHP_CONFIG="worker public/index.php"
ENV SERVER_NAME=":80"

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]
