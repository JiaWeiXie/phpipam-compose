ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-fpm-buster

WORKDIR /var/www/html

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    locales \
    locales-all \
    default-libmysqlclient-dev \
    gnupg2 \
    curl \
    fping \
    libcurl4-gnutls-dev \
    libgmp-dev \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libldap2-dev \
    libsnmp-dev \
    iputils-ping \
    libicu-dev \
    libonig-dev \
    libssl-dev \
    libxml2-dev \
    libpcre3 \
    libpcre3-dev

RUN locale-gen zh_TW.UTF-8 && update-locale LANG="zh_TW.UTF-8" LANGUAGE="zh_TW"
ENV LANG zh_TW.UTF-8
ENV LANGUAGE zh_TW

RUN pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt \
  && docker-php-ext-install \
  pdo \
  pdo_mysql \
  session \
  sockets \
  gettext \
  mbstring \
  json \
  pcntl \
  simplexml \
  gmp \
  ldap \
  gd \
  snmp

RUN curl -L https://github.com/phpipam/phpipam/releases/download/v1.5.2/phpipam-v1.5.2.tgz | tar -xvz -C /tmp/ \
  && mv /tmp/phpipam/* . \
  && apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log} \
  && rm -rf /tmp/* \
  && cp config.docker.php config.php \
  && ln /usr/bin/fping /bin/fping

VOLUME /var/www/html
