FROM php:7.0-apache

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
  zip 
  #dev

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# INSTALL COMPOSER
# -----------------------------
RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer --version=1.10.16 && chmod +x /usr/bin/composer 

# INSTALL XDEBUG
# -----------------------------
#ENV XDEBUG_PORT 9000
#RUN yes | pecl install xdebug && \
#   echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.iniOLD

# CONFIGURING SYSTEM
# -----------------------------
RUN chmod 777 -Rf /var/www /var/www/.* \
  && chown -Rf www-data:www-data /var/www /var/www/.* \
  && usermod -u 1000 www-data \
  && chsh -s /bin/bash www-data\
  && a2enmod rewrite \
  && a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html