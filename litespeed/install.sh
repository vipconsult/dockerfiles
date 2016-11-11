#!/bin/sh

cd `dirname "$0"`
source ./functions.sh 2>/dev/null
if [ $? != 0 ]; then
    . ./functions.sh
    if [ $? != 0 ]; then
        echo [ERROR] Can not include 'functions.sh'.
        exit 1
    fi
fi

LSINSTALL_DIR=`dirname "$0"`
cd $LSINSTALL_DIR

init

#LSWS_HOME=$1
#    WS_USER=nobody
#
#    WS_GROUP=nobody
#
#    ADMIN_USER=admin

#PASS_ONE=123456

#ADMIN_EMAIL=root@localhost
#ADMIN_PORT=7080
#HTTP_PORT=8088
#SETUP_PHP=1
#PHP_SUFFIX="php"
#DEFAULT_USER="nobody"
#DEFAULT_GROUP="nobody"

#license
#install_dir
#admin_login


if [ $INSTALL_TYPE = "reinstall" ]; then

   configAdminEmail
        getUserGroup
        stopLshttpd
        getServerPort
        getAdminPort
        configRuby
fi

cat <<EOF

Installing, please wait...

EOF

buildConfigFiles
installation
finish

