FROM whyour/qinglong:latest as main

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
WORkDIR ql/
COPY ./docker-entrypoint2.sh /docker/
EXPOSE 22 9003 5700
ENTRYPOINT ["./docker/docker-entrypoint2.sh"]


