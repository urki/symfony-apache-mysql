FROM php:7.1-apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/web

# enable a2enmod
RUN a2enmod rewrite

# install h4cc/wkhtmlto dependencies
RUN apt-get update && apt-get install -y \
      libfontconfig1 \
      libxrender1 \
      libxtst6 \
      libxi6 \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
       && docker-php-ext-install -j$(nproc) iconv mcrypt \
       && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
       && docker-php-ext-install -j$(nproc) gd
# install mysql pdo
RUN docker-php-ext-install pdo pdo_mysql


RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

