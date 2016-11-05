FROM debian

MAINTAINER Stan Velikov "stan@vip-consult.solutions"

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /home/php
RUN cd /home/php
RUN apt-get update && apt-get -y upgrade && apt-get -y install wget \
build-essential \
make \
lib32z1 \
lib32ncurses5 \
openssl \
libxml2-dev \
zlib1g-dev \
libcurl4-gnutls-dev \
libjpeg62-turbo-dev \
libpng-dev \
libfreetype6-dev \
libmcrypt-dev \
libxslt-dev \
libssl-dev \
pkg-config \
libc-client2007e-dev \
libkrb5-dev        #da moje se compilira php i da startira instalaciqta na litespeed
RUN wget http://uk1.php.net/get/php-5.6.27.tar.gz/from/this/mirror -O /home/php/php-5.6.27.tar.gz
RUN tar -zxvf /home/php/php-5.6.27.tar.gz -C /home/php/
RUN bash /home/php/php-5.6.27/configure \
'--enable-bcmath' \
'--enable-calendar' \
'--enable-exif' \
'--enable-ftp' \
'--enable-gd-native-ttf' \ 
'--enable-libxml' \
'--enable-mbstring' \
'--enable-pdo' \
'--enable-soap' \
'--enable-sockets' \ 
'--enable-zip' \
'--with-curl' \
'--with-gd' \
'--with-gettext' \ 
'--with-imap' \
'--with-imap-ssl' \
'--with-kerberos' \
'--with-mcrypt' \
'--with-mysql' \
'--with-openssl' \
'--with-pcre-regex' \
'--with-pdo-mysql' \ 
'--with-pic' \
'--with-xmlrpc' \ 
'--with-xsl' \
'--with-zlib' \
'--with-litespeed'

#RUN ./configure 
#--with-mysql-sock=/var/lib/mysql/mysql.sock 
RUN make
RUN make install

EXPOSE 3000
ADD run.sh /tmp/  
RUN chmod o+x /tmp/run.sh  
CMD ["/bin/bash", "-c", "/tmp/run.sh"]

#PHP_LSAPI_MAX_REQUESTS=500 PHP_LSAPI_CHILDREN=35 /usr/local/bin/lsphp -b *:7777

