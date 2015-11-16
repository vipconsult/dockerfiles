FROM php:5.6-fpm
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Setup supervisor
RUN apt-get install -y supervisor && \
    sed -i -e "s/var\/run\/\/supervisor.sock/var\/run\/\/supervisor_php.sock/g" /etc/supervisor/supervisord.conf

ADD supervisord.conf /etc/supervisor/conf.d/

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

CMD ["/usr/bin/supervisord"]