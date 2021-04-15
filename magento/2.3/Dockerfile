FROM php:7.2-apache

LABEL "AUTHOR" Leandro Ferrarotti <leandro.ferrarotti@25watts.com.ar>
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
RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer --version=1.10.16 && chmod +x /usr/bin/composer 

# INSTALL CODE SNIFFER
# -----------------------------
# RUN git clone https://github.com/magento/marketplace-eqp.git ~/.composer/vendor/magento/marketplace-eqp
# RUN cd ~/.composer/vendor/magento/marketplace-eqp && composer install
# RUN ln -s ~/.composer/vendor/magento/marketplace-eqp/vendor/bin/phpcs /usr/local/bin;

# ENV PATH="/var/www/.composer/vendor/bin/:${PATH}"

# INSTALL XDEBUG
# -----------------------------

#RUN pecl install xdebug && docker-php-ext-enable xdebug \

#ENV XDEBUG_PORT 9000
RUN pecl install -f xdebug \
&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini;

# INSTALL MHSENDMAIL
# -----------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

# INSTALL MAGERUN 2
# -----------------------------
# RUN wget https://files.magerun.net/n98-magerun2.phar \
#	&& chmod +x ./n98-magerun2.phar \
#	&& mv ./n98-magerun2.phar /usr/local/bin/

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/XDebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
ADD .docker/config/magento.conf /etc/apache2/sites-available/magento.conf
COPY .docker/bin/* /usr/local/bin/
COPY .docker/users/* /var/www/
RUN chmod +x /usr/local/bin/*
RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf

RUN curl -o /etc/bash_completion.d/m2install-bash-completion https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install-bash-completion
RUN curl -o /etc/bash_completion.d/n98-magerun2.phar.bash https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash
RUN echo "source /etc/bash_completion" >> /root/.bashrc
RUN echo "source /etc/bash_completion" >> /var/www/.bashrc

RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html