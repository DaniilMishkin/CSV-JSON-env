FROM php:8.4-cli

ARG APP_ENV
ARG UID
ARG GID

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get install -y git
RUN apt-get install -y unzip
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libzip-dev

# other libs
RUN apt-get install -y libmcrypt-dev libldap2-dev libfreetype6-dev libjpeg62-turbo-dev

RUN docker-php-ext-install intl opcache zip

## laravel requirements
RUN docker-php-ext-install pcntl && docker-php-ext-configure pcntl --enable-pcntl

## Database support (MySQL)
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Redis support
RUN pecl install redis && docker-php-ext-enable redis

# Decimal support
RUN apt-get -y install lsb-release ca-certificates curl
RUN curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
RUN dpkg -i /tmp/debsuryorg-archive-keyring.deb
RUN sh -c 'echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt-get update
RUN apt-get install -y libmpdec-dev
RUN pecl install decimal && docker-php-ext-enable decimal

# ext-uv support
RUN apt-get install -y libevent-dev
RUN apt-get install -y openssl libcurl4-openssl-dev pkg-config libssl-dev
RUN pecl install event
RUN docker-php-ext-enable --ini-name zz-event.ini event

# adding nano & mc
RUN apt-get install -y nano
RUN apt-get install -y mc
# changing 'www-data' user UID & GID
RUN usermod -u $UID -o www-data && groupmod -g $GID -o www-data
RUN mkdir /home/www-data
RUN usermod -d /home/www-data www-data

## PHP conf file
RUN if [ "$APP_ENV" = "local" ] ; \
        then cp '/usr/local/etc/php/php.ini-development' '/usr/local/etc/php/php.ini' ; \
        else cp '/usr/local/etc/php/php.ini-production' '/usr/local/etc/php/php.ini' ; \
    fi

USER www-data

WORKDIR '/var/www'
