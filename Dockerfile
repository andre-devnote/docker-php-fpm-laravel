FROM php:7.2-fpm
LABEL maintainer="André Santos <andre.forweb@gmail.com>"

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV DISABLE_BUILTIN_SERVER 0

COPY composer-install.sh /usr/local/bin/composer-install

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        procps \
        supervisor \
        libssl-dev \
        libcurl4-openssl-dev \
        libjpeg-dev \
        libpng-dev \
        libzip-dev \
        libmcrypt-dev \
        libreadline-dev \
        libxml2-dev \
        libmagickwand-dev \
        imagemagick \
        libxslt1-dev \
        libssl-dev \
        zip \
        unzip \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-zlib-dir \
    && docker-php-ext-install \
        gd \
        zip \
        soap \
        pdo_mysql \
        mysqli \
        xsl \
        opcache \
        calendar \
        intl \
        exif \
        bcmath \
        opcache \
    && pecl install redis \
    && pecl install mcrypt-1.0.1 \
    && pecl install imagick \
    && docker-php-ext-enable redis mcrypt imagick \
    && chmod +x /usr/local/bin/composer-install \
    && /usr/local/bin/composer-install \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && composer --version \
    && mkdir /.composer && chmod 777 /.composer \
    && mkdir /usr/local/log \
    && chown www-data:www-data /usr/local/log \
    && unlink /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "umask 0002" >> /etc/bash.bashrc

COPY php.ini /usr/local/etc/php/
COPY php-fpm.conf /usr/local/etc/
COPY php-fpm.d/www.conf /usr/local/etc/php-fpm.d/

COPY supervisor/supervisord.conf /etc/supervisor/
COPY supervisor/conf.d/ /etc/supervisor/conf.d/

COPY docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint
COPY exec.sh /usr/local/bin/exec.sh

RUN chmod +x /usr/local/bin/docker-php-entrypoint \
    && chmod +x /usr/local/bin/exec.sh

# arquivo default para testes
RUN mkdir /var/www/html/public \
    && echo "<?php phpinfo(); ?>" > /var/www/html/public/index.php \
    && chown -R www-data:www-data /var/www \
    && chmod -R g+rwX /var/www

WORKDIR /var/www/html

EXPOSE 9000
EXPOSE 9001

# para testes com o built-in server do PHP
EXPOSE 8000

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["/usr/bin/supervisord" , "-n",  "-c", "/etc/supervisor/supervisord.conf"]
