FROM php:8.1-fpm

# ARGS
ARG DOCKER_DIR
ARG NODE_VERSION

# Setup Installation
RUN apt-get clean \
    && apt-get update --fix-missing \
    && apt-get upgrade -y

# Platform Packages
RUN apt-get install -y \
    g++ \
    libbz2-dev \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libfreetype6-dev \
    openssh-client \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libldb-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libzip-dev \
    memcached \
    exif \
    wget \
    unzip \
    zlib1g-dev \
    supervisor \
    imagemagick \
    libxpm-dev \
    libwebp-dev \
    bash-completion

# EXTENTIONS (Direct Install)
RUN docker-php-ext-install -j$(nproc) \
    gettext \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    bcmath \
    xsl \
    exif

# EXTENTIONS (Configure & Install)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-configure pcntl \
    && docker-php-ext-install pcntl

# PECL
RUN pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install imagick && docker-php-ext-enable imagick

# Cleanup
RUN docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*


# Add Node, NPM & Yarn
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -
RUN apt-get update \
 && apt-get install -y \
 nodejs
RUN npm install -g npm@latest
RUN corepack enable

# Setup Supervisor
RUN mkdir -p "/etc/supervisor/logs"
COPY ${DOCKER_DIR}/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

# User
RUN groupadd -g 1000 supervisoruser
RUN useradd -u 1000 -ms /bin/bash -g supervisoruser supervisoruser
# USER supervisoruser

# Change ownership of yarn config directory
RUN mkdir -p /root/.config/yarn
RUN chown -R supervisoruser:supervisoruser /root/.config/yarn
RUN chown -R supervisoruser:supervisoruser /var/www/html
COPY --chown=supervisoruser:supervisoruser ${DOCKER_DIR}/php/php.ini /usr/local/etc/php/

# Launch
CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]
