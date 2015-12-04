if [ -n "${MYSQL_ROOT_PASSWORD}" ]; then
    mysqld_safe --skip-grant-tables --skip-networking &
    mysqladmin -u root password $MYSQL_ROOT_PASSWORD
fi
mysqld --wsrep_cluster_address=gcomm://$LB_SERVER