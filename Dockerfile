FROM php:7.1.28-apache
# Install php extensions
RUN pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable redis xdebug mysqli

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

# Install other required packages
RUN apt-get update && apt-get install git zip -y

# Install phpcs and php-cs-fixer
RUN composer global require "squizlabs/php_codesniffer=*" "friendsofphp/php-cs-fixer"
ENV PATH="~/.composer/vendor/bin:${PATH}"
