#Base image for the container
FROM php:8.2-apache
#Install GIT, GnuPG, NodeJS and NPM
RUN apt-get update && apt-get install -y git gnupg nano


#Add Laravel necessary php extensions
RUN apt-get install -y \
    libzip-dev\
    unzip \
    vim \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zip \
    && docker-php-ext-install zip mysqli pdo_mysql

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install gd

# Create working directory
RUN mkdir -p /var/www/codes
ENV APACHE_DOCUMENT_ROOT /var/www/codes/public
ENV APP_NAME "codes"
# Install composer from image. You may change it to the latest
COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/codes
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Make laravel feel comfortable with mod-rewrite
RUN a2enmod rewrite && service apache2 restart
EXPOSE 80
