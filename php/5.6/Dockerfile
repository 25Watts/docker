FROM php:5.6-apache

LABEL "ORGANIZATION" 25WATTS <dev@25watts.com.ar>
LABEL "AUTHOR" Alberto Urbaez <alberto.urbaez@25watts.com.ar>

# INSTALL SYSTEM DEPENDENCIES
# -----------------------------
RUN apt-get update \
    && apt-get install -y \
    libmcrypt-dev \
    libmcrypt4 \
    libcurl3-dev \
    libfreetype6 \
    libjpeg62-turbo \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    apt-utils \
    mariadb-server-core-10.1 \
    mariadb-server-10.1 \
    mariadb-client-10.1 \
    libxml2-dev \
    git \
    wget \
    zip \
    nano \
    gcc \
    make \
    autoconf \
    libc-dev \
    pkg-config

# INSTALL DEPENDENCIES
# -----------------------------
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install pdo \
    pdo_mysql \
    gd \
    mcrypt \
    mbstring \
    soap

# INSTALL OAUTH
# -----------------------------
RUN apt-get update \
    && pecl install oauth-1.2.3 \
    && echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# INSTALL XDEBUG
# -----------------------------
ENV XDEBUG_PORT 9000
RUN pecl install xdebug-2.5.5 && pecl channel-update pecl.php.net && docker-php-ext-enable xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini


# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/custom-xdebug.ini /usr/local/etc/php/conf.d/custom-xdebug.ini
# ADD .docker/config/php.ini /usr/local/etc/php/php.ini
# ADD .docker/config/magento.conf /etc/apache2/sites-available/magento.conf
# COPY .docker/bin/* /usr/local/bin/
# COPY .docker/users/* /var/www/
RUN chmod +x /usr/local/bin/*
# RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf

RUN chmod +x /usr/local/bin/*
RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME ["/var/www/html"]
WORKDIR /var/www/html