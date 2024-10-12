FROM php:8.1-fpm-alpine

# Aceptar argumentos de nombre de usuario y UID
ARG USER
ARG UID

RUN apk add sudo

# Set working directory
WORKDIR /var/www

# More dependencies list
# libpq-dev
# libpng-dev
# libzip-dev
# libonig-dev
# libxml2-dev
# libxslt-dev
# librabbitmq-dev

# Install system dependencies
RUN apk add --no-cache linux-headers
RUN apk update && apk add --no-cache ${PHPIZE_DEPS} \
    libxml2-dev \
    libpng-dev \
    libzip-dev \
    libxslt-dev \
    curl \
    postgresql-dev \
    imagemagick-dev \
    imagemagick \
    && pecl install imagick
RUN apk add zsh

# libmagickwand-dev \
# libonig-dev \

# Install PHP extensions
RUN docker-php-ext-install soap pdo pdo_pgsql exif pcntl bcmath gd intl zip xsl sockets
# RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
# amqp
RUN docker-php-ext-enable imagick

# Inicio Debug. Comentar o eliminar este bloque para producción ya que no es necesario hacer debug del código y puede afectar el rendimiento
# RUN pecl install xdebug
# RUN docker-php-ext-enable xdebug
# Fin Debug

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Clear cache
RUN rm -rf /var/cache/apk/*

# agregar usuario y grupo con el UID proporcionado y cambiar el nombre de usuario root al nombre de usuario proporcionado
 RUN addgroup -g $UID -S $USER && adduser -u $UID -S $USER -G $USER -s /bin/sh && adduser $USER www-data

RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Cambiar al usuario proporcionado
USER $USER

