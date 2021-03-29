FROM php:7.4-apache

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
    libzip-dev \
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
    zip \
  	bash-completion \
    && apt-get clean

# INSTALL DEPENDENCIES
# -----------------------------
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  docker-php-ext-install \
    gd \
    intl \
    pdo_mysql \
    xsl \
    opcache \
    sockets \
    bcmath \
    zip \
    soap

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
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends yarn && \
    npm install -g npm && \
    npm i -g grunt-cli

# INSTALL COMPOSER
# -----------------------------
RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer 

# INSTALL XDEBUG
# -----------------------------
ENV XDEBUG_PORT 9000
RUN yes | pecl install xdebug && \
	 echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/XDebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN chmod +x /usr/local/bin/*
RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html