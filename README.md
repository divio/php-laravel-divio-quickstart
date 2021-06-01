# PHP Laravel Divio quickstart

A Dockerised Laravel application, ready to deploy on Divio or another Docker-based cloud platform, and run
locally in Docker on your own machine. A Divio account is not required.

This version is based on the default Laravel example project and PHP 7.3.

## Try it

```bash
git clone git@github.com:divio/php-laravel-divio-quickstart.git
cd php-laravel-divio-quickstart
docker-compose build
```

Run database migrations:

```bash
docker-compose run web bash
```

followed by:

```bash
php artisan migrate
```

(An error can occur if the the MySQL service has failed to start up in time; in this case, wait a few moments and run
the command again).

Exit the shell.

Finally, start up the server:

```bash
docker-compose run web php /app/artisan migrate
docker-compose up
open http://127.0.0.1:8000/admin
```

For a more complete how-to guide for this project, see [Deploy a new PHP Laravel project using the Divio quickstart
repository](https://docs.divio.com/en/latest/how-to/quickstart-php-laravel/) in the [Divio Developer
Handbook](https://docs.divio.com).
