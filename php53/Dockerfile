FROM debian:squeeze
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get update && \
    apt-get install -y wget
 
RUN echo 'deb http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    echo 'deb-src http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    apt-get install -y wget && \
    wget http://www.dotdeb.org/dotdeb.gpg && \
    apt-key add dotdeb.gpg && \
    rm dotdeb.gpg && \
    apt-get update 


RUN apt-get install -y --no-install-recommends \
        php5 \
        php5-fpm \
        php5-gd \
        php5-imagick \
        php5-mysql \
        php5-mcrypt \
        php5-curl \
        php5-cli \
        php5-dev \
        php5-memcache \
        ssmtp

RUN sed -i "s/^.*FromLineOverride.*$/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf && \
    sed -i -e "s/;\?max_input_time =.*/max_input_time = 300/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;\?session.gc_divisor =.*/session.gc_divisor = 100/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;\?session.gc_maxlifetime =.*/session.gc_maxlifetime = 315360000/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;\?serialize_precision =.*/serialize_precision = 100/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;\?short_open_tag = Off/short_open_tag = On/" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;\?daemonize = yes/daemonize = no/" /etc/php5/fpm/php-fpm.conf && \
    sed -i -e "s/;\?listen =.*/listen = \/var\/run\/php53-fpm.sock/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/;\?pid =.*/pid = \/var\/run\/php53-fpm.pid/" /etc/php5/fpm/php-fpm.conf

# security enhancements
RUN find / -perm +6000 -type f -exec chmod a-s {} \; || true

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean


ADD start.sh start.sh

CMD ["/start.sh"]