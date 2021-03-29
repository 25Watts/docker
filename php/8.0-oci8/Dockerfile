FROM php:8.0-apache

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
    pdo_mysql \
    xsl \
    opcache \
    sockets \
    bcmath \
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
RUN apt install nodejs -y \
    && apt install npm -y \
    && npm i -g grunt-cli yarn

# INSTALL COMPOSER
# -----------------------------
RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer 

# INSTALL XDEBUG
# -----------------------------
ENV XDEBUG_PORT 9000
RUN yes | pecl install xdebug && \
   echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.iniOLD

RUN apt-get update && apt-get install -qqy git unzip libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libaio1 wget && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/ 

# ORACLE OCI
# -----------------------------
RUN mkdir /opt/oracle \
    && cd /opt/oracle     
    
ADD instantclient-basic-linux.x64-12.1.0.2.0.zip /opt/oracle
ADD instantclient-sdk-linux.x64-12.1.0.2.0.zip /opt/oracle

# INSTALL ORACLE INSTANTCLIENT
# -----------------------------
RUN  unzip /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
    && unzip /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
    && ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/instantclient_12_1/libclntsh.so \
    && ln -s /opt/oracle/instantclient_12_1/libclntshcore.so.12.1 /opt/oracle/instantclient_12_1/libclntshcore.so \
    && ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/instantclient_12_1/libocci.so \
    && rm -rf /opt/oracle/*.zip
    
ENV LD_LIBRARY_PATH  /opt/oracle/instantclient_12_1:${LD_LIBRARY_PATH}
    
# INSTALL ORACLE EXTENSIONS
# -----------------------------
RUN echo 'instantclient,/opt/oracle/instantclient_12_1/' | pecl install oci8 \ 
      && docker-php-ext-enable \
               oci8 \ 
       && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_12_1,12.1 \
       && docker-php-ext-install \
               pdo_oci 

# CONFIGURING SYSTEM
# -----------------------------
RUN chmod +x /usr/local/bin/*

RUN chmod 777 -Rf /var/www /var/www/.* \
  && chown -Rf www-data:www-data /var/www /var/www/.* \
  && usermod -u 1000 www-data \
  && chsh -s /bin/bash www-data\
  && a2enmod rewrite \
  && a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html