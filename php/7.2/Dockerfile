FROM php:7.2-apache

LABEL "AUTHOR" Alberto Urbaez <alberto.urbaez@25watts.com.ar>

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
    git \
    nano \
    wget \
    lynx \
    psmisc \
    libssl-dev \
  	libedit2 \
  	libxslt1-dev \
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
    soap

RUN apt-get update -y && \
    apt-get install -y libmcrypt-dev && \
    pecl install mcrypt-1.0.1 && \
    docker-php-ext-enable mcrypt

# INSTALL OAUTH
# -----------------------------
RUN apt-get update \
  	&& apt-get install -y \
  	libpcre3 \
  	libpcre3-dev \
  	&& pecl install oauth \
  	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# INSTALL NODE, NVM, NPM AND GRUNT
# -----------------------------
RUN apt install nodejs -y \
    && apt install npm -y \
    && npm i -g grunt-cli yarn

# INSTALL COMPOSER
# -----------------------------
RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer 

# INSTALL XDEBUG
# -----------------------------

#RUN pecl install xdebug && docker-php-ext-enable xdebug \

#ENV XDEBUG_PORT 9000
RUN pecl install -f xdebug \
&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini;

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/XDebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN chmod +x /usr/local/bin/*
RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html