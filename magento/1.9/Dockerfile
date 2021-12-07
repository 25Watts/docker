FROM php:5.6-apache

LABEL "ORGANIZATION" 25WATTS <dev@25watts.com.ar>
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

# INSTALL MAGENTO DEPENDENCIES
# -----------------------------
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install pdo \
    pdo_mysql \
    mysqli \
    gd \
    mcrypt \
    mbstring \
    soap

RUN chmod 777 -R /var/www \
    && chown -R www-data:1000 /var/www \
    && usermod -u 1000 www-data \
    && chsh -s /bin/bash www-data\
    && a2enmod rewrite \
    && a2enmod headers \
    && sed -i -e 's/\/var\/www\/html/\/var\/www\/htdocs/' /etc/apache2/apache2.conf

# INSTALL OAUTH
# -----------------------------
RUN apt-get update \
    && pecl install oauth-1.2.3 \
    && echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# INSTALL COMPOSER
# -----------------------------
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# INSTALL MHSENDMAIL
# -----------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

# INSTALL XDEBUG
# -----------------------------
ENV XDEBUG_PORT 8999
RUN pecl install xdebug-2.5.5 && pecl channel-update pecl.php.net && docker-php-ext-enable xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.iniOLD

# INSTALL MAGERUN
# -----------------------------
# RUN wget https://files.magerun.net/n98-magerun.phar --no-check-certificate \
#     && chmod +x ./n98-magerun.phar \
#     && mv ./n98-magerun.phar /usr/local/bin/

# INSTALL MODMAN
# -----------------------------
RUN wget https://raw.githubusercontent.com/colinmollenhour/modman/master/modman -O /usr/local/bin/modma

# INSTALL SSH
# -----------------------------
# RUN apt-get update && apt-get install -y openssh-server openssh-client
# RUN mkdir /var/run/sshd
# RUN echo 'root:root' | chpasswd
# RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile

# RUN /etc/init.d/apache2 restart

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/magento.conf /etc/apache2/sites-available/magento.conf
ADD .docker/config/custom-xdebug.ini /usr/local/etc/php/conf.d/custom-xdebug.ini
COPY .docker/bin/* /usr/local/bin/
COPY .docker/users/* /var/www/
RUN chmod +x /usr/local/bin/*
RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf

VOLUME ["/var/www/html"]
WORKDIR /var/www/html
#COPY ./src /var/www/html

#CMD ["apache2-foreground", "-DFOREGROUND"]