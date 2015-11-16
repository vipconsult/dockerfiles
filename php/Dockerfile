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



RUN apt-get update && apt-get install -y --no-install-recommends wget


RUN echo "deb http://packages.dotdeb.org wheezy-php55 all" >> /etc/apt/sources.list && \
	echo "deb-src http://packages.dotdeb.org wheezy-php55 all">> /etc/apt/sources.list
RUN wget http://www.dotdeb.org/dotdeb.gpg&& apt-key add dotdeb.gpg&& rm dotdeb.gpg

RUN 	apt-get update

RUN 	apt-get install -y --no-install-recommends \
	php5 \
        php5-fpm \
        php5-gd \
        php5-imagick \
	ghostscript \
        php5-mysql \
        php5-pgsql \
        php5-mcrypt \
        php5-memcache \
        php5-curl \
        ssmtp

RUN sed -i "s/^.*FromLineOverride.*$/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf && \
    # downlod cert chain as without this curl over https returns an error
    wget http://curl.haxx.se/ca/cacert.pem --directory-prefix=/etc/php5/fpm && \
    wget http://www.symantec.com/content/en/us/enterprise/verisign/roots/Class-3-Public-Primary-Certification-Authority.pem --directory-prefix=/etc/php5/fpm/ && \
    cat /etc/php5/fpm/Class-3-Public-Primary-Certification-Authority.pem >> /etc/php5/fpm/cacert.pem && \
    rm /etc/php5/fpm/Class-3-Public-Primary-Certification-Authority.pem && \
    sed -i 's/^.*curl.cainfo.*$/curl.cainfo =\/etc\/php5\/fpm\/cacert.pem/' /etc/php5/fpm/php.ini && \
    #set some additional php params
    sed -i 's/^.*post_max_size.*$/post_max_size = 500M/' /etc/php5/fpm/php.ini && \
    sed -i 's/^.*upload_max_filesize =.*$/upload_max_filesize = 500M/' /etc/php5/fpm/php.ini && \
    sed -i 's/^.*short_open_tag =.*$/short_open_tag = On/' /etc/php5/fpm/php.ini && \
    sed -i 's/^.*max_execution_time.*$/max_execution_time = 60/' /etc/php5/fpm/php.ini && \
    sed -i 's/^.*max_input_vars.*$/max_input_vars = 5000/' /etc/php5/fpm/php.ini && \
    sed -i 's/^.*error_reporting = .*$/error_reporting = E_ALL \& ~E_DEPRECATED/' /etc/php5/fpm/php.ini && \
    sed -i 's/^.*default_socket_timeout.*$/default_socket_timeout = 120/' /etc/php5/fpm/php.ini && \
    sed -i 's/^.*date.timezone.*$/date.timezone = Europe\/London/' /etc/php5/fpm/php.ini && \
    
    sed -i 's/^.*daemonize.*$/daemonize = no/' /etc/php5/fpm/php-fpm.conf && \

    sed -i 's/^.*listen =.*$/listen = \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/^.*listen.owner =.*$/listen.owner = nobody/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/^.*listen.group =.*$/listen.group = nogroup/' /etc/php5/fpm/pool.d/www.conf

# Setup supervisor
RUN apt-get install -y supervisor && \
    sed -i -e "s/var\/run\/\/supervisor.sock/var\/run\/\/supervisor_php.sock/g" /etc/supervisor/supervisord.conf

ADD supervisord.conf /etc/supervisor/conf.d/

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

CMD ["/usr/bin/supervisord"]
