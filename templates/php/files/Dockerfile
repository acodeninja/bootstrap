# syntax=docker/dockerfile:1
FROM composer:2.11.2 AS composer

FROM php:8.6.0-cli-trixie

COPY --from=composer /usr/bin/composer /usr/bin/composer

# PHPUnit needs mbstring, and Composer needs unzip for dist downloads; the
# cli-trixie image ships neither.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends libonig-dev unzip \
    && docker-php-ext-install mbstring \
    && rm -rf /var/lib/apt/lists/*

ENV COMPOSER_HOME=/cache/composer
ENV COMPOSER_VENDOR_DIR=/tools/vendor
ENV PATH=/tools/vendor/bin:$PATH

# The dev tools install to /tools, not /work, so they never collide with a
# vendor/ this project creates for its own dependencies later.
RUN mkdir -p /tools /cache/composer /cache/phpunit /cache/phpstan /cache/php-cs-fixer \
    && printf '{"require-dev":{"phpunit/phpunit":"13.4.8","phpstan/phpstan":"2.3.7","friendsofphp/php-cs-fixer":"3.95.32"}}' > /tools/composer.json \
    && composer install --working-dir=/tools --no-interaction --no-progress \
    && chmod -R 777 /cache

WORKDIR /work
