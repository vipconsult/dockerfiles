FROM debian:squeeze
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get update && \
    apt-get install -y wget
 
RUN echo 'deb http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    echo 'deb-src http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    
    apt-get install wget && \
    wget http://www.dotdeb.org/dotdeb.gpg && \
    apt-key add dotdeb.gpg && \
    rm dotdeb.gpg && \
    apt-get update 


RUN apt-get install -y \
        exim4 \
        php5 \
        php5-fpm \
        php5-gd \
        php5-imagick \
        php5-mysql \
        php5-mcrypt \
        php5-memcache \
        php5-curl \
        php5-memcache \
        memcached 

ADD update-exim4.conf.conf /etc/exim4/


RUN update-exim4.conf && \
    sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php5/fpm/php.ini  && \
    sed -i -e "s/post_max_size = 8M/post_max_size = 50M/g" /etc/php5/fpm/php.ini   && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 500M/g" /etc/php5/fpm/php.ini   && \
    sed -i -e "s/max_execution_time = 30/max_execution_time = 60/g" /etc/php5/fpm/php.ini   && \
    sed -i -e "s/max_input_vars = 1000/max_input_vars = 5000/g" /etc/php5/fpm/php.ini   && \
    sed -i -e "s/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/error_reporting = E_ALL \& ~E_DEPRECATED/g" /etc/php5/fpm/php.ini   && \
    sed -i -e "s/default_socket_timeout = 60/default_socket_timeout = 120/g" /etc/php5/fpm/php.ini   && \
    sed -i -e "s/;date.timezone =/date.timezone = Europe\/London/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php53-fpm.sock/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pid = \/var\/run\/php5-fpm.pid/pid = \/var\/run\/php53-fpm.pid/g" /etc/php5/fpm/php-fpm.conf && \

    sed -i -e "s/;listen.owner = www-data/listen.owner = www-data/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.group = www-data/listen.group = www-data/g" /etc/php5/fpm/pool.d/www.conf && \
    
    sed -i -e "s/;daemonize = yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# Setup supervisor
RUN apt-get install -y supervisor
ADD supervisord.conf /etc/supervisor/conf.d/ 
RUN sed -i -e "s/var\/run\/\/supervisor.sock/var\/run\/\/supervisor_php53.sock/g" /etc/supervisor/supervisord.conf

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

CMD ["/usr/bin/supervisord"]

