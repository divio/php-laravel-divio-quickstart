FROM php:7.3-fpm-stretch

# Expose the container's port 80
EXPOSE 80

# Install system dependencies
RUN apt-get update && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor mysql-client nginx dumb-init
# Install some convenience Docker PHP binaries
RUN docker-php-ext-install mbstring pdo pdo_mysql

# Set the working directory
WORKDIR /app
# Copy the repository files to it
COPY . /app
# Copy the nginx vhost configuration
COPY divio/nginx_vhost.conf /etc/nginx/sites-available/default

# Install Composer into /usr/bin/
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer


# ---- commands that amend files in /app ----

# see https://docs.divio.com/en/latest/how-to/quickstart-php-laravel/#mapping-app-to-the-host

# Install application-level dependencies
RUN composer install --no-scripts --no-autoloader

# Create directories required by PHP storage and caching
RUN mkdir -p bootstrap/cache storage storage/framework storage/framework/sessions storage/framework/views storage/framework/cache
RUN chmod -R 777 storage/framework

RUN bash -c "cp /app/.env.example /app/.env \
    && composer dump-autoload \
    && php artisan key:generate \
    && php artisan package:discover"


# Set the correct mode on the Divio helper modules
RUN chmod 0755 divio/ensure-env.sh
RUN chmod 0755 divio/run-locally.sh

# ---- end of commands that amend files in /app ----


CMD php /app/divio/run-env.php "/usr/bin/dumb-init nginx && php-fpm -R"
