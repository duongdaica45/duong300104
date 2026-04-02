FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    git \
    curl \
    libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# Cài thêm extension quan trọng
RUN docker-php-ext-install mbstring

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

COPY .env.example .env

RUN chmod -R 777 storage bootstrap/cache

RUN composer install --no-dev --optimize-autoloader --no-scripts

RUN php artisan key:generate

RUN php artisan config:cache

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000
