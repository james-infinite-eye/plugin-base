FROM wordpress:php8.0-apache

ENV XDEBUG_PORT 9003

ARG XDEBUG_REMOTE_HOST=host.docker.internal

RUN yes | pecl install xdebug && \
    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini && \
    # xdebug 2
    # echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    # echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    # echo "xdebug.remote_host=$XDEBUG_REMOTE_HOST" >> /usr/local/etc/php/conf.d/xdebug.ini
    # xdebug 3
    echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.client_host=$XDEBUG_REMOTE_HOST" >> /usr/local/etc/php/conf.d/xdebug.ini

#
# TMP symbolic link conf files
# 
# RUN mv /etc/apache2/mods-enabled/alias.conf /etc/apache2/mods-available/alias.conf && ln -s /etc/apache2/mods-available/alias.conf /etc/apache2/mods-enabled/alias.conf && \
#     mv /etc/apache2/mods-enabled/autoindex.conf /etc/apache2/mods-available/autoindex.conf && ln -s /etc/apache2/mods-available/autoindex.conf /etc/apache2/mods-enabled/autoindex.conf && \
#     mv /etc/apache2/mods-enabled/deflate.conf /etc/apache2/mods-available/deflate.conf && ln -s /etc/apache2/mods-available/deflate.conf /etc/apache2/mods-enabled/deflate.conf && \
#     mv /etc/apache2/mods-enabled/dir.conf /etc/apache2/mods-available/dir.conf && ln -s /etc/apache2/mods-available/dir.conf /etc/apache2/mods-enabled/dir.conf && \
#     mv /etc/apache2/mods-enabled/mime.conf /etc/apache2/mods-available/mime.conf && ln -s /etc/apache2/mods-available/mime.conf /etc/apache2/mods-enabled/mime.conf && \
#     mv /etc/apache2/mods-enabled/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf && ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf && \
#     mv /etc/apache2/mods-enabled/negotiation.conf /etc/apache2/mods-available/negotiation.conf && ln -s /etc/apache2/mods-available/negotiation.conf /etc/apache2/mods-enabled/negotiation.conf && \
#     mv /etc/apache2/mods-enabled/reqtimeout.conf /etc/apache2/mods-available/reqtimeout.conf && ln -s /etc/apache2/mods-available/reqtimeout.conf /etc/apache2/mods-enabled/reqtimeout.conf && \
#     mv /etc/apache2/mods-enabled/setenvif.conf /etc/apache2/mods-available/setenvif.conf && ln -s /etc/apache2/mods-available/setenvif.conf /etc/apache2/mods-enabled/setenvif.conf && \
#     mv /etc/apache2/mods-enabled/status.conf /etc/apache2/mods-available/status.conf && ln -s /etc/apache2/mods-available/status.conf /etc/apache2/mods-enabled/status.conf
#
# Install SSL Cert
# 
RUN apt-get update && \
    apt-get install -y --no-install-recommends ssl-cert && \
    a2enmod ssl && \
    a2ensite default-ssl

COPY mailcatcher.php /var/www/html/wp-content/mu-plugins/mailcatcher.php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN apt-get update && \
    apt-get install -y gnupg2 && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get -y install yarn

# RUN apt-get update && \
#     apt-get install -y subversion && \
#     curl https://phar.phpunit.de/phpunit-7.5.phar -L -o phpunit-7.5.phar && \
#     chmod +x phpunit-7.5.phar && \
#     mv phpunit-7.5.phar /usr/local/bin/phpunit

RUN apt-get update && \
    apt-get install -y zip subversion default-mysql-client git && \
    apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

# Install PHPUNIT Fix for PHP8
RUN curl -L https://github.com/woocommerce/phpunit/archive/add-compatibility-with-php8-to-phpunit-7.zip -o /tmp/phpunit-7.5-fork.zip \
    && unzip -d /tmp/phpunit-7.5-fork /tmp/phpunit-7.5-fork.zip

RUN apt update && apt install -y libc-client-dev libkrb5-dev \
        && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
        && docker-php-ext-install imap \
        && docker-php-ext-enable imap

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 9003