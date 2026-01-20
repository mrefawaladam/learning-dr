FROM dunglas/frankenphp:1.1-php8.3

WORKDIR /var/www

# ==============================
# ENV (PRODUCTION)
# ==============================
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV OCTANE_SERVER=frankenphp
ENV LOG_CHANNEL=stderr

# ==============================
# FRANKENPHP WORKER MODE
# ==============================
ENV FRANKENPHP_WORKERS=1
ENV FRANKENPHP_DISABLE_HTTPS=1

# ==============================
# OPCACHE (SINGLE CPU SAFE)
# ==============================
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

# ==============================
# SYSTEM DEPS
# ==============================
RUN apt-get update && apt-get install -y \
    git unzip curl \
 && rm -rf /var/lib/apt/lists/*

# ==============================
# APP SOURCE
# ==============================
COPY src /var/www

# ==============================
# COMPOSER
# ==============================
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --classmap-authoritative \
    --no-interaction

# ==============================
# LARAVEL OPTIMIZATION
# ==============================
RUN php artisan key:generate --force \
 && php artisan config:clear \
 && php artisan route:clear \
 && php artisan view:clear

# ==============================
# PERMISSIONS
# ==============================
RUN chown -R www-data:www-data /var/www \
 && chmod -R 775 storage bootstrap/cache

EXPOSE 8000

# ==============================
# START FRANKENPHP (WORKER MODE)
# ==============================
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]


