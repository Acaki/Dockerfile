FROM php:7.4.3-apache

# Install other required packages
RUN apt-get update && apt-get install git zip libcurl4-openssl-dev pkg-config libssl-dev libxml2-dev -y

# Install php extensions
RUN pecl install redis \
    && pecl install xdebug \
    && pecl install mongodb \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install soap \
    && docker-php-ext-install pcntl \
    && docker-php-ext-enable redis xdebug mongodb

# Enable htacess rewrte function
RUN a2enmod rewrite headers
# Write xdebug configurations
RUN echo "xdebug.remote_port=9000" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.default_enable=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/php.ini

# Install composer
RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer


# Install phpcs and php-cs-fixer
RUN composer global require "squizlabs/php_codesniffer=*" "friendsofphp/php-cs-fixer"
ENV PATH="~/.composer/vendor/bin:${PATH}"
