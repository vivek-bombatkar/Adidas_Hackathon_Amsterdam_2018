FROM composer:1.6
FROM php:7.2-apache

RUN apt-get update \
    && apt-get install -y \
		git

ENV APCU_VERSION 5.1.9
RUN set -xe \
	&& apt-get update && apt-get install -y \
		$PHPIZE_DEPS \
		zlib1g-dev \
		libpq-dev \
		libicu-dev \
	&& docker-php-ext-install \
		intl \
		pdo_pgsql \
		zip \
	&& pecl install \
		apcu-${APCU_VERSION} \
	&& docker-php-ext-enable --ini-name 20-apcu.ini apcu \
	&& docker-php-ext-enable --ini-name 05-opcache.ini opcache

COPY --from=0 /usr/bin/composer /usr/bin/composer
COPY docker/php-asl/php.ini /usr/local/etc/php/php.ini
COPY docker/php-asl/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY docker/php-asl/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN chmod +x /usr/local/bin/docker-entrypoint


RUN a2enmod rewrite

ENV APACHE_DOCUMENT_ROOT /srv/api/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /srv/api
ENTRYPOINT ["docker-entrypoint"]
CMD ["apache2-foreground"]

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative

# Prevent the reinstallation of vendors at every changes in the source code
COPY composer.json composer.lock ./
RUN composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress --no-suggest \
	&& composer clear-cache

COPY . ./

RUN mkdir -p var/cache var/logs var/sessions \
	&& composer dump-autoload --classmap-authoritative --no-dev \
	&& chown -R www-data var

# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "$SSH_PASSWD" | chpasswd

COPY docker/php-asl/sshd_config /etc/ssh/

EXPOSE 2222