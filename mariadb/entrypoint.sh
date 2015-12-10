#!/bin/bash
set -e

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
        set -- mysqld "$@"
fi

if [ -n "${LB_SERVER}" ]; then      
    # the ip of the other node to connect to and don't wait it is offline  
    sed -i "s/wsrep_cluster_address =.*/wsrep_cluster_address = gcomm:\/\/$INTERNAL_IP,$LB_SERVER?pc.wait_prim=no/" /etc/mysql/my.cnf
    sed -i "s/wsrep_sst_auth =.*/wsrep_sst_auth = root:$MYSQL_ROOT_PASSWORD/" /etc/mysql/my.cnf
fi

if [ -n "${INTERNAL_IP}" ]; then
#    # the galera daemon listens on this ip
#    sed -i "s/.*wsrep_provider_options =.*/wsrep_provider_options='gmcast.listen_addr=$INTERNAL_IP'/" /etc/mysql/my.cnf 

    sed -i "s/.*wsrep_provider_options =.*/wsrep_provider_options = 'gcache.size = 3G'/" /etc/mysql/my.cnf 
    # set the internal ip manually as otherwise the detection doesn't work   
    sed -i "s/.*wsrep_node_address =.*/wsrep_node_address = $INTERNAL_IP/" /etc/mysql/my.cnf 
fi
 
if [ -n "${MYSQL_innodb_buffer_pool_size}" ]; then
    sed -i "s/.*innodb_buffer_pool_size =.*/innodb_buffer_pool_size = $MYSQL_innodb_buffer_pool_size/" /etc/mysql/my.cnf         
fi


if [ "$1" = 'mysqld' ]; then
    # Get config
    #this crashes on 10.1
    #DATADIR="$("$@" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"
    DATADIR=/var/lib/mysql

    if [ ! -d "$DATADIR/mysql" ]; then
            if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" ]; then
                    echo >&2 'error: database is uninitialized and MYSQL_ROOT_PASSWORD not set'
                    echo >&2 '  Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
                    exit 1
            fi

            mkdir -p "$DATADIR"
            chown -R mysql:mysql "$DATADIR"

            echo 'Initializing database'
            mysql_install_db --user=mysql --datadir="$DATADIR" --rpm
            echo 'Database initialized'

            "$@" --wsrep-new-cluster --skip-networking &
            pid="$!"

            mysql=( mysql --protocol=socket -uroot )

            for i in {30..0}; do
                    if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
                            break
                    fi
                    echo 'MySQL init process in progress...'
                    sleep 1
            done
            if [ "$i" = 0 ]; then
                    echo >&2 'MySQL init process failed.'
                    exit 1
            fi

            if [ -z "$MYSQL_INITDB_SKIP_TZINFO" ]; then
                    # sed is for https://bugs.mysql.com/bug.php?id=20545
                    mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/Local time zone must be set--see zic manual page/FCTY/' | "${mysql[@]}" mysql
            fi

            "${mysql[@]}" <<-EOSQL
                    -- What's done in this file shouldn't be replicated
                    --  or products like mysql-fabric won't work
                    SET @@SESSION.SQL_LOG_BIN=0;
                    DELETE FROM mysql.user ;
                    CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
                    GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
                    DROP DATABASE IF EXISTS test ;
                    FLUSH PRIVILEGES ;
EOSQL

            if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
                    mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )
            fi

            if [ "$MYSQL_DATABASE" ]; then
                    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" | "${mysql[@]}"
                    mysql+=( "$MYSQL_DATABASE" )
            fi

            if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
                    echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" | "${mysql[@]}"

                    if [ "$MYSQL_DATABASE" ]; then
                            echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" | "${mysql[@]}"
                    fi

                    echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
            fi

            echo
            for f in /docker-entrypoint-initdb.d/*; do
                    case "$f" in
                            *.sh)  echo "$0: running $f"; . "$f" ;;
                            *.sql) echo "$0: running $f"; "${mysql[@]}" < "$f" && echo ;;
                            *)     echo "$0: ignoring $f" ;;
                    esac
                    echo
            done

            if ! kill -s TERM "$pid" || ! wait "$pid"; then
                    echo >&2 'MySQL init process failed.'
                    exit 1
            fi

            echo
            echo 'MySQL init process done. Ready for start up.'
            echo
    fi

    chown -R mysql:mysql "$DATADIR"
    if [ -n "${MYSQL_PRIMARY}" ]; then
        set -- mysqld --wsrep-new-cluster
    fi
fi

exec "$@"
