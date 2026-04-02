FROM php:8.2-cli

# Cài extension
RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_pgsql

# Cài composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy code
COPY . .

# Tạo .env từ example
COPY .env.example .env

# Cấp quyền cho Laravel
RUN chmod -R 777 storage bootstrap/cache

# Cài dependency (QUAN TRỌNG: thêm --no-scripts)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Generate key
RUN php artisan key:generate

# Cache config (tối ưu)
RUN php artisan config:cache

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000
