FROM vipconsult/base:jessie

RUN apt-get install wget unzip make automake g++ libevent-dev && \
    wget --no-check-certificate https://github.com/memcached/memcached/archive/1.2.1.zip && \
    unzip 1.2.1.zip && \
    cd memcached-1.2.1 && \
     ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -Rf memcached-1.2.1 1.2.1.zip && \
    apt-get purge wget unzip make automake g++ && \
    apt-get autoremove

CMD /usr/local/bin/memcached -u root
