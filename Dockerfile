# 1. Gunakan image dasar
FROM dunglas/frankenphp:1-php8.3

# 2. Install ekstensi PHP yang dibutuhkan Laravel
RUN install-php-extensions \
    pcntl \
    pdo_mysql \
    gd \
    intl \
    zip \
    opcache

# 3. Set direktori kerja
WORKDIR /app

# 4. Copy file aplikasi (dari folder src)
COPY src .

# 5. Set environment variable untuk Worker Mode
ENV FRANKENPHP_CONFIG="worker public/index.php"

# 6. Expose port
EXPOSE 80
EXPOSE 443

# 7. Jalankan server menggunakan Octane
ENTRYPOINT ["php", "artisan", "octane:frankenphp"]
