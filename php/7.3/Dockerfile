FROM php:7.3-apache

LABEL "ORGANIZATION" 25WATTS <dev@25watts.com.ar>
LABEL "AUTHOR" Alberto Urbaez <alberto.urbaez@25watts.com.ar>

# SET DEFAULT ENVIRONMENT
# -----------------------------
# ENV XDEBUG_PORT=9000

# INSTALL SYSTEM DEPENDENCIES
# -----------------------------
RUN apt-get update \
    && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    libzip-dev \
    git \
    nano \
    wget \
    lynx \
    psmisc \
    libssl-dev \
  	libedit2 \
  	apt-utils \
  	gnupg \
  	redis-tools \
  	curl \
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
    gd \
    intl \
    mbstring \
    pdo_mysql \
    xsl \
    opcache \
    sockets \
    bcmath \
    zip \
    xml \
    soap

RUN apt-get update && apt-get install -y libmcrypt-dev \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt

# INSTALL OAUTH
# -----------------------------
RUN apt-get update \
  	&& apt-get install -y \
  	libpcre3 \
  	libpcre3-dev \
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

RUN chmod +x /usr/local/bin/*

RUN chown -R www-data:www-data /var/www
RUN find /var/www -type f -exec chmod 664 {} \;
RUN find /var/www -type d -exec chmod 775 {} \;

RUN usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html