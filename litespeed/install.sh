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
#license
install_dir
admin_login


if [ $INSTALL_TYPE = "reinstall" ]; then

    configAdminEmail
        getUserGroup
        stopLshttpd
        getServerPort
        getAdminPort
        configRuby
        enablePHPHandler
fi

cat <<EOF

Installing, please wait...

EOF

buildConfigFiles

installation

#setupPHPAccelerator
installAWStats
#importApacheConfig
finish

