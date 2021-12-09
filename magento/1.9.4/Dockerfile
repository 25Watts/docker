FROM 25watts/php:7.2

LABEL "ORGANIZATION" 25WATTS <dev@25watts.com.ar>

# SET DEFAULT ENVIRONMENT
# -----------------------------
ENV COMPOSER_VERSION="1.10.16"

# INSTALL COMPOSER
# -----------------------------
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} && chmod +x /usr/bin/composer 

# INSTALL MHSENDMAIL
# -----------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
    && mkdir /opt/go \
    && export GOPATH=/opt/go \
    && go get github.com/mailhog/mhsendmail

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/magento.conf /etc/apache2/sites-available/magento.conf
COPY .docker/bin/* /usr/local/bin/
COPY .docker/users/* /var/www/
RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf

RUN curl -o /etc/bash_completion.d/m2install-bash-completion https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install-bash-completion
RUN curl -o /etc/bash_completion.d/n98-magerun2.phar.bash https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash
RUN echo "source /etc/bash_completion" >> /root/.bashrc
RUN echo "source /etc/bash_completion" >> /var/www/.bashrc

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