FROM php:5.6.27-cli

MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

ENV OpenLiteSpeed 1.4.17-2 ~ trusty
ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

#RUN mkdir /home/php
#RUN cd /home/php
RUN apt-get update && apt-get -y upgrade && apt-get -y install wget nano \
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
libkrb5-dev        #required to configure php 

RUN apt-get -y install php5-mcrypt php5-gd php5-mysql php5-curl php5-sybase php5-odbc freetds-common 
RUN wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash \
&& apt-get -y install lsphp56 lsphp56-mysql lsphp56-gd lsphp56-mcrypt lsphp56-imap lsphp56-curl lsphp56-xmlrpc lsphp56-xsl lsphp56-dev lsphp56-odbc
RUN  apt-get -y install freetds-bin tdsodbc unixodbc
RUN sed -i -e "s/;extension=php_shmop.dll/extension=pdo.so/" /usr/local/lsws/lsphp56/etc/php.ini
RUN sed -i -e "s/;extension=php_pgsql.dll/extension=mssql.so/" /usr/local/lsws/lsphp56/etc/php.ini

#RUN wget http://uk1.php.net/get/php-5.6.27.tar.gz/from/this/mirror -O /home/php/php-5.6.27.tar.gz
#RUN tar -zxvf /home/php/php-5.6.27.tar.gz -C /home/php/
#RUN bash /home/php/php-5.6.27/configure \
#'--enable-bcmath' \
#'--enable-calendar' \
#'--enable-exif' \
#'--enable-ftp' \
#'--enable-gd-native-ttf' \ 
#'--enable-libxml' \
#'--enable-mbstring' \
#'--enable-pdo' \
#'--enable-soap' \
#'--enable-sockets' \ 
#'--enable-zip' \

#'--with-curl' \ #
#'--with-gd' \#
#'--with-gettext' \ 
#'--with-imap' \
#'--with-imap-ssl' \
#'--with-kerberos' \
#'--with-mcrypt' \
#'--with-mysql' \
#'--with-openssl' \
#'--with-pcre-regex' \
#'--with-pdo-mysql' \ 
#'--with-pic' \
#'--with-xmlrpc' \ 
#'--with-xsl' \
#'--with-zlib' \
#'--with-litespeed'

#--with-mysql-sock=/var/lib/mysql/mysql.sock 
#RUN make
#RUN make install

EXPOSE 3000
ENV PHP_LSAPI_MAX_REQUESTS=500 
ENV PHP_LSAPI_CHILDREN=35
#CMD ["/bin/bash", "-c", "/usr/local/bin/lsphp -b *:7777"]#/usr/local/lsws/lsphp56/bin/lsphp -b *:7777
CMD ["/bin/bash", "-c", "/usr/local/lsws/lsphp56/bin/lsphp -b *:7777"]

