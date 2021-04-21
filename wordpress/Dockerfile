FROM php:7.2-apache

LABEL "ORGANIZATION" 25WATTS <dev@25watts.com.ar>
LABEL "AUTHOR" Alberto Urbaez <alberto.urbaez@25watts.com.ar>

# SET DEFAULT ENVIRONMENT
# -----------------------------
ENV COMPOSER_VERSION="1.10.16" \
    NODE_VERSION="setup_10.x"

# INSTALL NODE, NVM, NPM AND GRUNT
# -----------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg && \
    curl -sL https://deb.nodesource.com/${NODE_VERSION} | bash - && \
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
--install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} && chmod +x /usr/bin/composer 

# CONFIGURING SYSTEM
# -----------------------------
ADD .docker/config/local.lan.conf /etc/apache2/sites-available/local.lan.conf
RUN ln -s /etc/apache2/sites-available/local.lan.conf /etc/apache2/sites-enabled/local.lan.conf
