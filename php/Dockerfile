FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get update
    
RUN apt-get install -y \
        php5 \
        php5-fpm \
        php5-gd \
        php5-imagick \
        php5-mysql \
        php5-pgsql \
        php5-mcrypt \
        php5-memcache \
        php5-curl \
        php5-memcache \
        memcached \
        ssmtp


RUN sed -i "s/^.*FromLineOverride.*$/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf && \
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
    sed -i 's/^.*listen.owner =.*$/listen.owner = www-data/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/^.*listen.group =.*$/listen.group = www-data/' /etc/php5/fpm/pool.d/www.conf

# Setup supervisor
RUN apt-get install -y supervisor && \
    sed -i -e "s/var\/run\/\/supervisor.sock/var\/run\/\/supervisor_php.sock/g" /etc/supervisor/supervisord.conf

ADD supervisord.conf /etc/supervisor/conf.d/

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

CMD ["/usr/bin/supervisord"]
