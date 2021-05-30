FROM php:7.1-apache

LABEL "ORGANIZATION" 25WATTS <dev@25watts.com.ar>
LABEL "AUTHOR" Alberto Urbaez <alberto.urbaez@25watts.com.ar>

# INSTALL SYSTEM DEPENDENCIES
# -----------------------------
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  software-properties-common \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libfreetype6-dev \
  libicu-dev \
  libssl-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libedit-dev \
  libedit2 \
  libxslt1-dev \
  apt-utils \
  gnupg \
  redis-tools \
  mariadb-server \
  git \
  nano \
  wget \
  curl \
  lynx \
  psmisc \
  unzip \
  tar \
  cron \
  bash-completion \
  && apt-get clean

# INSTALL DEPENDENCIES
# -----------------------------
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  docker-php-ext-install \
  opcache \
  gd \
  bcmath \
  intl \
  mbstring \
  mcrypt \
  pdo_mysql \
  soap \
  xsl \
  xml \
  zip 
  #dev

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# INSTALL OAUTH
# -----------------------------
RUN apt-get update \
    && apt-get install -y \
    libpcre3 \
    libpcre3-dev \
  # php-pear \
    && pecl install oauth \
    && echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# INSTALL XDEBUG
# -----------------------------
RUN pecl install -f xdebug-3.0.3
RUN docker-php-ext-enable xdebug

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/XDebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN chmod 777 -Rf /var/www /var/www/.* \
  && chown -Rf www-data:www-data /var/www /var/www/.* \
  && usermod -u 1000 www-data \
  && chsh -s /bin/bash www-data\
  && a2enmod rewrite \
  && a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html