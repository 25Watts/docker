ARG PHP_VERSION=7.3
FROM php:${PHP_VERSION}-apache
USER root

LABEL "AUTHOR" Leandro Ferrarotti <leandro.ferrarotti@25watts.com.ar>
LABEL "AUTHOR" Alberto Urbaez <alberto.urbaez@25watts.com.ar>
LABEL "AUTHOR" José Amietta <jose.amietta@25watts.com.ar>

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

# INSTALL MAGENTO DEPENDENCIES
# -----------------------------
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  docker-php-ext-install \
    gd \
    intl \
    mbstring \
    pdo_mysql \
    xsl \
    zip \
    opcache \
    sockets \
    bcmath \
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
RUN	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
RUN composer global require hirak/prestissimo

# INSTALL CODE SNIFFER
# -----------------------------
# RUN git clone https://github.com/magento/marketplace-eqp.git ~/.composer/vendor/magento/marketplace-eqp
# RUN cd ~/.composer/vendor/magento/marketplace-eqp && composer install
# RUN ln -s ~/.composer/vendor/magento/marketplace-eqp/vendor/bin/phpcs /usr/local/bin;

# ENV PATH="/var/www/.composer/vendor/bin/:${PATH}"

# INSTALL XDEBUG
# -----------------------------
ENV XDEBUG_PORT 9000
RUN yes | pecl install xdebug && \
	 echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.iniOLD

# INSTALL MHSENDMAIL
# -----------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/magento.conf /etc/apache2/sites-available/magento.conf
ADD .docker/config/custom-xdebug.ini /usr/local/etc/php/conf.d/custom-xdebug.ini
COPY .docker/bin/* /usr/local/bin/
COPY .docker/users/* /var/www/
RUN chmod +x /usr/local/bin/*
RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf

RUN chmod 2775 /var/www && find /var/www -type d -exec chmod 2775 {} \; \
  && find /var/www -type f -exec chmod 0664 {} \; \
  && chown -Rf www-data:www-data /var/www \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html
USER www-data
