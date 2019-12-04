FROM alpine:3.9

EXPOSE 8080

WORKDIR /var/www

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates \
    && echo "http://dl-cdn.alpinelinux.org/alpine/v3.9/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.9/community" >> /etc/apk/repositories && \
    echo "@php https://dl.bintray.com/php-alpine/v3.9/php-7.3" >> /etc/apk/repositories \
    && apk add --update \
    && apk add --no-cache \
    autoconf \
    build-base \
    g++ \
    libressl-dev \
    make \
    pcre2-dev \
    tzdata \
    wget \
    && apk add --no-cache \
    ca-certificates \
    git \
    libffi-dev \
    libxslt \
    openssl-dev \
    supervisor \
    php@php \
    php-mbstring@php \
    php-bcmath@php \
    php-bz2@php \
    php-calendar@php \
    php-common@php \
    php-ctype@php \
    php-curl@php \
    php-dev@php \
    php-dom@php \
    php-exif@php \
    php-fpm@php \
    php-gd@php \
    php-iconv@php \
    php-zlib@php \
    php-intl@php \
    php-json@php \
    php-ldap@php \
    php-redis@php \
    php-mbstring@php \
    php-mysqli@php \
    php-mysqlnd@php \
    php-opcache@php \
    php-openssl@php \
    php-pdo@php \
    php-pdo_mysql@php \
    php-pdo_sqlite@php \
    php-pear@php \
    php-phar@php \
    php-session@php \
    php-soap@php \
    php-sockets@php \
    php-sqlite3@php \
    php-xml@php \
    php-xmlreader@php \
    php-xmlrpc@php \
    php-xsl@php \
    php-zip@php \
    php-gmp@php \
    php-ftp@php \
    php-mongodb@php \
    && rm -f $(find /etc/php7/conf.d -type f | grep sockets) \
    && cp /usr/bin/phpize7 /usr/bin/phpize \
    && cp /usr/bin/php7 /usr/bin/php \
    && pecl channel-update pecl.php.net \
    && printf "yes\n" | pecl install swoole \
    && echo -e 'extension=sockets.so\nextension=swoole.so\n' >> /etc/php7/php.ini \
    && pecl clear-cache \
    && wget https://getcomposer.org/composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
    && echo "Asia/Taipei" >  /etc/timezone \
    && rm -rf /var/cache/apk/*

COPY ./docker/supervisord.conf /etc/supervisor.d/supervisord.ini
    
CMD /usr/bin/supervisord -n -c /etc/supervisord.conf;
