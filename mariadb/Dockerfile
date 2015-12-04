FROM vipconsult/base:jessie


RUN apt-get install \
        wget \
        unzip \
        cmake \
        make \
        g++ \
        libncurses5-dev \
        bison

RUN wget --no-check-certificate https://github.com/MariaDB/server/archive/10.1.zip && \
    unzip 10.1.zip &&\
    cd server-10.1 &&\
    cmake ./
    make
    make isntall

# don't reverse lookup hostnames, they are usually another container
RUN sed -i '/[mysqld]/a\nskip-host-cache\nskip-name-resolve' /etc/mysql/my.cnf && \
    sed -i '/[galera]/a\n \
        wsrep_provider=\/usr\/lib\/galera\/libgalera_smm.so \n \
        binlog_format=row \n \
        bind-address=$INTERNAL_IP \n \
        default_storage_engine=InnoDB \n \
        innodb_autoinc_lock_mode=2 \n \
        innodb_doublewrite=1 \n \
        query_cache_size=0 \n \
        wsrep_on=on \n \
        innodb_flush_log_at_trx_commit=0 \n \
        /' /etc/mysql/my.cnf
COPY start.sh /
CMD ["/start.sh"]