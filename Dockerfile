FROM whyour/qinglong:latest as main

LABEL maintainer="Jorge Arco <jorge.arcoma@gmail.com>"

RUN apk --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/main add \
    icu-libs \
    &&apk --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/community add \
    # Current packages don't exist in other repositories
    libavif \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted gnu-libiconv \
    # Packages
    tini \
    php81 \
    php81-dev \
    php81-common \
    php81-gd \
    php81-xmlreader \
    php81-bcmath \
    php81-ctype \
    php81-curl \
    php81-exif \
    php81-iconv \
    php81-intl \
    php81-mbstring \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-phar \
    php81-session \
    php81-xml \
    php81-xsl \
    php81-zip \
    php81-zlib \
    php81-dom \
    php81-fpm \
    php81-sodium \
    # Iconv Fix
    php81-pecl-apcu \
    && ln -s /usr/bin/php81 /usr/bin/php

COPY --from=jorge07/alpine-php:8.1-dev /rootfs/ /

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/php-fpm81", "-R", "--nodaemonize"]

EXPOSE 9000


FROM main as dev

ARG USER=root
ARG PASSWORD=root

ARG COMPOSER_VERSION=2.2.1

RUN apk add -U --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/   \
        php81-pear \
        openssh \
        supervisor \
        autoconf \
        git \
        curl \
        wget \
        make \
        zip \
        php81-xdebug \
    # Delete APK cache.
    && rm -rf /var/cache/apk/* \
    # Create ssh user for dev.
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && echo "${USER}:${PASSWORD}" | chpasswd \
    && ssh-keygen -A \
    # Download composer.
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}

COPY --from=jorge07/alpine-php:8.1-dev /devfs/ /
WORkDIR ql/
COPY ./docker-entrypoint2.sh /docker/
EXPOSE 22 9003 5700
ENTRYPOINT ["./docker/docker-entrypoint2.sh"]


