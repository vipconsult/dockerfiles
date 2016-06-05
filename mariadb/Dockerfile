FROM vipconsult/base:jessie

ENV MARIADB_MAJOR 10.1
ENV MARIADB_VERSION 10.1.13+maria-1~jessie

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    echo "deb [arch=amd64,i386] http://ftp.cc.uoc.gr/mirrors/mariadb/repo/$MARIADB_MAJOR/debian jessie main"> /etc/apt/sources.list.d/mariadb.list &&\
    
    
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

    # install the percone backup utlitity
    apt-get install \
        socat \
        libcurl3 \
        libev4 && \
    wget --no-check-certificate  https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.3.2/binary/debian/jessie/x86_64/percona-xtrabackup_2.3.2-1.jessie_amd64.deb && \
    dpkg -i percona-xtrabackup_2.3.2-1.jessie_amd64.deb && \

    #install the backup compress utility
    wget --no-check-certificate  http://www.quicklz.com/qpress-11-linux-x64.tar && \
    tar xvf qpress-11-linux-x64.tar && \
    mv qpress /usr/bin/qpress && \
    rm qpress-11-linux-x64.tar && \
    rm percona-xtrabackup_2.3.2-1.jessie_amd64.deb && \
    rm -rf /var/lib/mysql && \
	rm -rf /var/lib/apt/lists/*


# don't reverse lookup hostnames, they are usually another container
RUN sed -i '/\[mysqld\]/ a skip-host-cache\nskip-name-resolve\n#innodb_force_recovery =' /etc/mysql/my.cnf && \
    sed -i "s/wait_timeout.*/wait_timeout = 7200/" /etc/mysql/my.cnf && \
    sed -i "/\[galera\]/ a \
        # these are added empty as they are replaces with env variables in the entry script
        wsrep_cluster_address = \n \
        wsrep_provider_options = \n \
        wsrep_node_address =\n \
        wsrep_sst_auth =\n \
        bind-address = 0.0.0.0 \n \
        wsrep_provider = \/usr\/lib\/galera\/libgalera_smm.so \n \
        wsrep_sst_method = xtrabackup-v2 \n \
        binlog_format = row \n \
        default_storage_engine = InnoDB \n \
        innodb_autoinc_lock_mode = 2 \n \
        innodb_doublewrite = 1 \n \
        query_cache_size = 0 \n \
        wsrep_on = on \n \
        innodb_flush_log_at_trx_commit = 0 \n \
        " /etc/mysql/my.cnf

COPY entrypoint.sh /
RUN chmod 777 /entrypoint.sh  \
    && sed -i -e 's/\r$//' /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]