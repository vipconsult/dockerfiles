FROM vipconsult/base:jessie

ENV MARIADB_MAJOR 10.1

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    echo  "deb [arch=amd64,i386] http://ftp.cc.uoc.gr/mirrors/mariadb/repo/$MARIADB_MAJOR/debian jessie main"> /etc/apt/sources.list.d/mariadb.list &&\
    
    # add repository pinning to make sure dependencies from this MariaDB repo are preferred over Debian dependencies
    { \
		echo 'Package: *'; \
		echo 'Pin: release o=MariaDB'; \
		echo 'Pin-Priority: 999'; \
	} > /etc/apt/preferences.d/mariadb && \
        apt-get update && \
	apt-get install \
            galera-arbitrator-3 && \
	rm -rf /var/lib/mysql && \
	rm -rf /var/lib/apt/lists/*

ENV NODES=172.31.17.122:4567,172.31.45.9:4567

CMD ["garbd -a gcomm://$NODES:4567?pc.wait_prim=no  -g my_wsrep_cluster"]
#garbd -a gcomm://$NODES:4567?pc.wait_prim=no -o ist.recv_addr=$INTERNAL_IP  -g my_wsrep_cluster
#gmcast.base_port=