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

RUN sh -c "/app/setup.sh"

CMD php /app/divio/run-env.php "/usr/bin/dumb-init nginx && php-fpm -R"
