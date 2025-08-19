FROM php:8.4-fpm

ARG APP_ENV
ARG UID
ARG GID

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libzip-dev
RUN apt-get install -y libicu-dev


# other libs
RUN apt-get install -y git unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev libldap2-dev


RUN docker-php-ext-install intl opcache zip

## laravel requirements
RUN docker-php-ext-install pcntl && docker-php-ext-configure pcntl --enable-pcntl

## Database support (MySQL)
RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

# Redis support
RUN pecl install redis && docker-php-ext-enable redis


# XDebug (for 'dev' env only)
RUN if [ "$APP_ENV" = "local" ] ; \
    then pecl install xdebug \
        && docker-php-ext-enable xdebug \
        && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
        && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; \
    fi

# adding nano & mc
RUN apt-get install -y nano
RUN apt-get install -y mc
# changing 'www-data' user UID & GID
RUN usermod -u $UID -o www-data && groupmod -g $GID -o www-data
RUN mkdir /home/www-data
RUN usermod -d /home/www-data www-data

# PHP conf file
RUN if [ "$APP_ENV" = "local" ] ; \
        then cp '/usr/local/etc/php/php.ini-development' '/usr/local/etc/php/php.ini' ; \
        else cp '/usr/local/etc/php/php.ini-production' '/usr/local/etc/php/php.ini' ; \
    fi

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR '/var/www'

CMD ["php-fpm"]
