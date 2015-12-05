FROM vipconsult/base:jessie

ENV MARIADB_MAJOR 10.1
ENV MARIADB_VERSION 10.1.9+maria-1~jessie

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    echo  "deb [arch=amd64,i386] http://ftp.cc.uoc.gr/mirrors/mariadb/repo/$MARIADB_MAJOR/debian jessie main"> /etc/apt/sources.list.d/mariadb.list &&\
    
    # add repository pinning to make sure dependencies from this MariaDB repo are preferred over Debian dependencies
    { \
		echo 'Package: *'; \
		echo 'Pin: release o=MariaDB'; \
		echo 'Pin-Priority: 999'; \
	} > /etc/apt/preferences.d/mariadb && \
    { \
            echo mariadb-server-$MARIADB_MAJOR mysql-server/root_password password 'unused'; \
            echo mariadb-server-$MARIADB_MAJOR mysql-server/root_password_again password 'unused'; \
	} | debconf-set-selections && \
        apt-get update && \
	apt-get install \
            mariadb-server=$MARIADB_VERSION && \
	rm -rf /var/lib/mysql && \
	rm -rf /var/lib/apt/lists/*

# don't reverse lookup hostnames, they are usually another container
RUN sed -i '/\[mysqld\]/ a skip-host-cache\nskip-name-resolve' /etc/mysql/my.cnf && \
    sed -i "/\[galera\]/ a \
        wsrep_cluster_address= \n \
        wwsrep_provider_options= \n \
        bind-address=127.0.0.1 \n \
        wsrep_provider=\/usr\/lib\/galera\/libgalera_smm.so \n \
        binlog_format=row \n \
        default_storage_engine=InnoDB \n \
        innodb_autoinc_lock_mode=2 \n \
        innodb_doublewrite=1 \n \
        query_cache_size=0 \n \
        wsrep_on=on \n \
        innodb_flush_log_at_trx_commit=0 \n \
        " /etc/mysql/my.cnf

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]