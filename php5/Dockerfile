FROM php:5.6-fpm
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

# Install modules
RUN echo 'APT::NeverAutoRemove "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Update::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \

    apt-get update && \
    apt-get install wget && \
    apt-get install libmcrypt-dev && \
        docker-php-ext-install mcrypt  && \
    apt-get install libfreetype6-dev libjpeg62-turbo-dev libpng12-dev && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ &&\
        docker-php-ext-install gd && \
    ## imagick
    apt-get install libmagickwand-dev && \
        mkdir -p /usr/src/php/ext && curl -L https://pecl.php.net/get/imagick >> /usr/src/php/ext/imagick.tgz && \
        tar -xf /usr/src/php/ext/imagick.tgz -C /usr/src/php/ext/ && \
        rm /usr/src/php/ext/imagick.tgz && \
        mv -T /usr/src/php/ext/imagick* /usr/src/php/ext/imagick && \
        docker-php-ext-install imagick && \
        docker-php-ext-install mysql && \
        docker-php-ext-install mysqli && \
    apt-get install libcurl4-openssl-dev && \
        docker-php-ext-install curl && \
        docker-php-ext-install exif && \
        docker-php-ext-install gettext && \
        docker-php-ext-install mbstring && \
        docker-php-ext-install pdo_mysql && \
        docker-php-ext-install shmop && \
        docker-php-ext-install sockets && \
        docker-php-ext-install opcache && \
        docker-php-ext-install zip && \

        #pgsql
    apt-get install libpq-dev && \
        docker-php-ext-install pgsql && \
        docker-php-ext-install pdo_pgsql && \
        #soap
    apt-get install libxml2-dev && \
        docker-php-ext-install soap && \
        docker-php-ext-install wddx && \
    apt-get install \
        ssmtp  \
        nano  \
        ghostscript && \
        #pdf builded
        sed -i "s/^.*FromLineOverride.*$/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf && \
        #memcached
    apt-get install php-pear curl zlib1g-dev libncurses5-dev libmemcached-dev && \
        curl -L https://pecl.php.net/get/memcached/2.1.0 >> /usr/src/php/ext/memcache.tgz && \
        tar -xf /usr/src/php/ext/memcache.tgz -C /usr/src/php/ext/ && \
        rm /usr/src/php/ext/memcache.tgz && \
        mv -T /usr/src/php/ext/memcache* /usr/src/php/ext/memcache && \
        docker-php-ext-install memcache && \

    apt-get purge -y --auto-remove && \
        rm -rf /var/lib/apt/lists/* && \
        apt-get clean


RUN cp /usr/src/php/php.ini-development /usr/local/etc/php/php.ini && \

    # downlod cert chain as without this curl over https returns an error
    wget http://curl.haxx.se/ca/cacert.pem --directory-prefix=/usr/local/etc && \
    wget http://www.symantec.com/content/en/us/enterprise/verisign/roots/Class-3-Public-Primary-Certification-Authority.pem --directory-prefix=/usr/local/etc/ && \
    cat /usr/local/etc/Class-3-Public-Primary-Certification-Authority.pem >> /usr/local/etc/php/cacert.pem && \
    rm /usr/local/etc/Class-3-Public-Primary-Certification-Authority.pem && \

    # global php sesstings - the strart up script sets the env settins
    sed -i 's/^.*curl.cainfo.*$/curl.cainfo =\/usr\/local\/etc\/php\/cacert.pem/' /usr/local/etc/php/php.ini && \
    sed -i 's/^.*short_open_tag =.*$/short_open_tag = On/' /usr/local/etc/php/php.ini && \
    sed -i 's/^.*always_populate_raw_post_data =.*$/always_populate_raw_post_data = -1/' /usr/local/etc/php/php.ini && \
    sed -i 's/^.*sendmail_path =.*$/sendmail_path = sendmail -t -i/' /usr/local/etc/php/php.ini && \

    if ! grep -lq "pm.status_path =" /usr/local/etc/php-fpm.conf  ; then  printf  "\npm.status_path = /status" >> /usr/local/etc/php-fpm.conf ; else sed -i -e "s/;\?pm.status_path =.*/pm.status_path = \/status/" /usr/local/etc/php-fpm.conf ;fi

# add an older certificate bundle  to fix an issue with some ssl websites
RUN cd /usr/local/share/ca-certificates && \
    wget --no-check-certificate  https://raw.githubusercontent.com/bagder/ca-bundle/e9175fec5d0c4d42de24ed6d84a06d504d5e5a09/ca-bundle.crt && \
    update-ca-certificates

ADD entrypoint.sh /entrypoint.sh
RUN chmod o+x /entrypoint.sh  \
    && sed -i -e 's/\r$//' /entrypoint.sh
CMD ["/entrypoint.sh"]
