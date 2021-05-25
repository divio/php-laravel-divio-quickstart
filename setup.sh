#!/bin/bash

# This script contains commands that amend files in /app/.
#
# By listing them here and calling the script from the Dockerfile (rather than executing each one in
# the Dockerfile), it makes it easier to run them all when required, for example when using Docker
# Compose in a configuration that overwrites files in /app with files from the host. This is useful
# for development purposes.
#
# To execute the script, run source setup.sh (or docker-compose run web source setup.sh).
#
# See https://docs.divio.com/en/latest/how-to/quickstart-php-laravel/#mapping-app-to-the-host for
# more.

# Install application-level dependencies
composer install --no-scripts --no-autoloader


# Create directories required by PHP storage and caching
mkdir -p bootstrap/cache storage storage/framework storage/framework/sessions storage/framework/views storage/framework/cache
chmod -R 777 storage/framework


bash -c "cp /app/.env.example /app/.env \
    && composer dump-autoload \
    && php artisan key:generate \
    && php artisan package:discover"


# Set the correct mode on the Divio helper modules
chmod 0755 divio/ensure-env.sh
chmod 0755 divio/run-locally.sh
