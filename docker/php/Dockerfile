FROM ghcr.io/laravel-frankenphp/frankenphp:2.4

WORKDIR /var/www

# =====================================================
# PHP OPCACHE (PRODUCTION - SINGLE CPU OPTIMIZED)
# =====================================================
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=128
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=20000
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_PRELOAD=/var/www/preload.php
ENV PHP_OPCACHE_PRELOAD_USER=www-data

# =====================================================
# LARAVEL / OCTANE ENV
# =====================================================
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV OCTANE_SERVER=frankenphp

# =====================================================
# COPY SOURCE
# =====================================================
COPY src /var/www

# =====================================================
# INSTALL DEPENDENCIES (OPTIMIZED)
# =====================================================
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --classmap-authoritative

# =====================================================
# LARAVEL OPTIMIZATION
# (TANPA CACHE DATABASE)
# =====================================================
RUN php artisan key:generate --force \
 && php artisan config:clear \
 && php artisan route:clear \
 && php artisan view:clear

# =====================================================
# PERMISSIONS
# =====================================================
RUN chown -R www-data:www-data /var/www \
 && chmod -R 775 storage bootstrap/cache

EXPOSE 8000

# =====================================================
# FRANKENPHP WORKER MODE (SINGLE CPU SAFE)
# =====================================================
CMD ["frankenphp", "serve", \
     "--host=0.0.0.0", \
     "--port=8000", \
     "--prod", \
     "--workers=1"]
