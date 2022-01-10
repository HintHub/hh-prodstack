# php-fpm

#    - /etc/php/7.4/cli/php.ini
#    - /etc/php/7.4/cli/conf.d/10-opcache.ini
#    - /etc/php/7.4/cli/conf.d/10-pdo.ini
#    - /etc/php/7.4/cli/conf.d/20-calendar.ini
#    - /etc/php/7.4/cli/conf.d/20-ctype.ini
#    - /etc/php/7.4/cli/conf.d/20-curl.ini
#    - /etc/php/7.4/cli/conf.d/20-exif.ini
#    - /etc/php/7.4/cli/conf.d/20-ffi.ini
#    - /etc/php/7.4/cli/conf.d/20-fileinfo.ini
#    - /etc/php/7.4/cli/conf.d/20-ftp.ini
#    - /etc/php/7.4/cli/conf.d/20-gettext.ini
#    - /etc/php/7.4/cli/conf.d/20-iconv.ini
#    - /etc/php/7.4/cli/conf.d/20-json.ini
#    - /etc/php/7.4/cli/conf.d/20-phar.ini
#    - /etc/php/7.4/cli/conf.d/20-posix.ini
#    - /etc/php/7.4/cli/conf.d/20-readline.ini
#    - /etc/php/7.4/cli/conf.d/20-shmop.ini
#    - /etc/php/7.4/cli/conf.d/20-sockets.ini
#    - /etc/php/7.4/cli/conf.d/20-sysvmsg.ini
#    - /etc/php/7.4/cli/conf.d/20-sysvsem.ini
#    - /etc/php/7.4/cli/conf.d/20-sysvshm.ini
#    - /etc/php/7.4/cli/conf.d/20-tokenizer.ini

FROM php:fpm-alpine
RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add git
RUN apk add icu-libs
RUN apk add icu-dev

RUN echo "ipv6" >> /etc/modules
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install intl

RUN apk add --update \
    make \
    curl \
    nodejs \
    npm \
    yarn

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions \
    mysqli \
    pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

#ADD php.ini /etc/php/conf.d/
#ADD php.ini /etc/php/cli/conf.d/
#ADD php.ini /usr/local/etc/php
#ADD php-fpm.conf /etc/php/php-fpm.d/

RUN wget https://get.symfony.com/cli/installer -O - | bash
#RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

CMD ["php", "/var/www/bin/console", "doctrine:database:drop", "--force", "-n"]
CMD ["php", "/var/www/bin/console", "doctrine:database:create", "-n"]
CMD ["php", "/var/www/bin/console", "doctrine:migrations:migrate", "-n"]
CMD [ "php", "/var/www/bin/console", "doctrine:fixtures:load", "-n"]

CMD ["php-fpm"]

EXPOSE 9000
