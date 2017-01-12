#!/bin/sh
show_help()
{
    cat <<EOF

# Command:
#    lsws_whm_autoinstaller.sh SERIAL_NO PHP_SUEXEC port_offset admin_user admin_pass admin_email
#
# Example:
#    lsws_whm_autoinstaller.sh TRIAL 2 1000 admin a1234567 root@localhost
#
#    For security reasons, it is recommended that you supply all parameters instead of using defaults.
#
# Input parameters:
#
# 1. (Required) SERIAL_NO
#    This will register the server using the serial number specified and retrieve a license key.
#    Inputting "TRIAL" will cause a trial key to be requested and installed.
#
# 2. (Optional) PHP_SUEXEC
#    Available values are 0 (disable), 1 (enable), 2 (user home directory only).
#    Default is 2.
#
# 3. (Optional) port_offset
#    Controls the Apache port offset. This allows you to run LiteSpeed in parallel with Apache to test it out.
#    For example, if you set port offset to 1000, Apache will continue running on port 80 and LiteSpeed will
#    run on port 1080.
#    If port offset is set to 0, LiteSpeed will be ready to replace Apache as the main web server (after you
#    stop Apache and start LiteSpeed).
#    Default is 1000.
#
# 4. (Optional) admin_user
#    Admin user name for accessing the LiteSpeed WebAdmin console.
#    Default is "admin".
#
# 5. (Optional) admin_pass
#    Admin user password for accessing the LiteSpeed WebAdmin console.
#    It is recommended that you set your own password and not use the default one.
#    Default is "a1234567"
#
# 6. (Optional) admin_email
#    Admin user's email. This email address will receive important server notices, such as license expiring or
#    server core dumps.
#    Default is "root@localhost"
#

EOF

    exit 1
}

# Download files will be in /usr/src/lsws
WGET_TEMP=/usr/src/lsws
# LiteSpeed will be installed to /usr/local/lsws
LSWS_HOME=/usr/local/lsws


# check params
if [ $# -eq 0 ] ; then
    echo "Invalid params!"
    show_help
fi

SERIAL="$1"
echo "Serial Number is ${SERIAL}"

#PHP_SUEXEC
if [ $# -gt 1 ] ; then
    if [ "$2" -eq 0 ] || [ "$2" -eq 1 ] || [ "$2" -eq 2 ] ; then
        PHP_SUEXEC_INPUT="$2"  # 0 or 1 or 2
    else
        echo "Invalid PHP_SUEXEC param!"
        show_help
    fi
else
    PHP_SUEXEC_INPUT=2
fi
PHP_SUEXEC="$PHP_SUEXEC_INPUT"
echo "PHP_SUEXEC = $PHP_SUEXEC"

#AP_PORT_OFFSET
if [ $# -gt 2 ] ; then
    if [ `expr "$3" : '.*[^0-9]'` -gt 0 ] ; then
        echo "Invalid port_offset param!"
        show_help
    else
        AP_PORT_OFFSET_INPUT="$3"
    fi
else
    AP_PORT_OFFSET_INPUT=1000
fi
AP_PORT_OFFSET="$AP_PORT_OFFSET_INPUT"
echo "Apache Port Offset = ${AP_PORT_OFFSET}"

#ADMIN USER
if [ $# -gt 3 ] ; then
    ADMIN_USER="$4"
else
    ADMIN_USER="admin"
fi
echo "Admin User = ${ADMIN_USER}"

#ADMIN PASS
if [ $# -gt 4 ] ; then
    ADMIN_PASS=`expr length "$5"`
    if [ $ADMIN_PASS -lt 6 ] ; then
        echo "admin pass is too short!"
        show_help
    fi
    if [ $ADMIN_PASS -gt 64 ] ; then
        echo "admin pass is too long!"
        show_help
    fi
    ADMIN_PASS="$5"
else
    ADMIN_PASS="a1234567"
fi
echo "Admin Password = ${ADMIN_PASS}"

#ADMIN EMAIL
if [ $# -gt 5 ] ; then
    if [ `expr "$6" : '^[^@]*@[^@]*$'` -gt 0 ] ; then
        ADMIN_EMAIL_INPUT="$6"
    else
        echo "Invalid admin email!"
        show_help
    fi
else
    ADMIN_EMAIL_INPUT="root@localhost"
fi
ADMIN_EMAIL="$ADMIN_EMAIL_INPUT"
echo "Admin Email = ${ADMIN_EMAIL}"


echo ""
echo ""

check_errs()
{
  if [ "${1}" -ne "0" ] ; then
    echo "**ERROR** ${2}"
    exit ${1}
  fi
}


download_lsws()
{
    PF=`uname -p`
    OS=`uname -s`

    echo "... Query latest release version ..."

    DOWNLOAD_URL="http://update.litespeedtech.com/ws/latest.php"

    REL_VERSION=`wget -q --output-document=- $DOWNLOAD_URL`

    REL_VERSION=`expr "$REL_VERSION" : '.*LSWS=\([0-9\.]*\)'`
#    REL_VERSION=5.0.19
    echo "Lastest version is $REL_VERSION"
    echo ""

    MAJOR_VERSION=`expr $REL_VERSION : '\([0-9]*\)\..*'`
    LOCAL_DIR="lsws-$REL_VERSION"

#    DOWNLOAD_URL="http://www.litespeedtech.com/packages/$MAJOR_VERSION.0/lsws-$REL_VERSION-ent-x86_64-linux.tar.gz"
     DOWNLOAD_URL="http://www.litespeedtech.com/packages/$MAJOR_VERSION.0/lsws-$REL_VERSION-std-i386-linux.tar.gz"
    if [ ! -d "$WGET_TEMP" ] ; then
        mkdir -v -p "$WGET_TEMP"
        check_errs $? "error when creating downloading directory ... abort!"
        echo "  Download directory created"
    fi

    if [ -e "$WGET_TEMP/$LOCAL_DIR.tar.gz" ]; then
        /bin/rm -f "$WGET_TEMP/$LOCAL_DIR.tar.gz"
        echo "Package downloaded before, remove the old copy"
    fi

    echo "... Downloading ... $DOWNLOAD_URL"
    wget -q --output-document=$WGET_TEMP/$LOCAL_DIR.tar.gz $DOWNLOAD_URL
    check_errs $? "error when downloading ... abort!"

    echo "Download finished successfully"

}


test_license()
{
    if [ -f "$LSWS_HOME/conf/license.key" ] && [ ! -f "$LSINSTALL_DIR/license.key" ]; then
        cp "$LSWS_HOME/conf/license.key" "$LSINSTALL_DIR/license.key"
    fi
    if [ -f "$LSWS_HOME/conf/serial.no" ] && [ ! -f "$LSINSTALL_DIR/serial.no" ]; then
        cp "$LSWS_HOME/conf/serial.no" "$LSINSTALL_DIR/serial.no"
    fi
    if [ -f "$LSINSTALL_DIR/license.key" ] && [ -f "$LSINSTALL_DIR/serial.no" ]; then
        echo "License key and serial number are available, testing..."
        echo
        $LSINSTALL_DIR/bin/lshttpd -t
        if [ $? -eq 0 ]; then
            LICENSE_OK=1
        fi
        echo
    fi

    if [ "x$LICENSE_OK" = "x" ]; then
        if [ -f "$LSINSTALL_DIR/serial.no" ]; then
            echo "Serial number is available."
            echo "Contacting licensing server ..."

            $LSINSTALL_DIR/bin/lshttpd -r

            if [ $? -eq 0 ]; then
                echo "[OK] License key received."
                $LSINSTALL_DIR/bin/lshttpd -t

                if [ $? -eq 0 ]; then
                    LICENSE_OK=1
                else
                    echo "The license key received does not work."
                fi
            fi
        fi
    fi

    if [ "x$LICENSE_OK" = "x" ]; then
        if [ -f "$LSINSTALL_DIR/trial.key" ]; then
            $LSINSTALL_DIR/bin/lshttpd -t
            check_errs $? "Invalid license key, abort!"
        else
            check_errs 1 "Invalid license key, abort!"
        fi

    fi

}

installLicense()
{
    if [ -f $LSINSTALL_DIR/serial.no ]; then
        cp -f $LSINSTALL_DIR/serial.no $LSWS_HOME/conf
        chown "$DIR_OWN" $LSWS_HOME/conf/serial.no
        chmod "$CONF_MOD" $LSWS_HOME/conf/serial.no
    fi

    if [ -f $LSINSTALL_DIR/license.key ]; then
        cp -f $LSINSTALL_DIR/license.key $LSWS_HOME/conf
        chown "$DIR_OWN" $LSWS_HOME/conf/license.key
        chmod "$CONF_MOD" $LSWS_HOME/conf/license.key
    fi

    if [ -f $LSINSTALL_DIR/trial.key ]; then
        cp -f $LSINSTALL_DIR/trial.key $LSWS_HOME/conf
        chown "$DIR_OWN" $LSWS_HOME/conf/trial.key
        chmod "$CONF_MOD" $LSWS_HOME/conf/trial.key
    fi
}


install_lsws()
{
    cd "$WGET_TEMP/"
    echo "... Extracting... tar -zxf $WGET_TEMP/$LOCAL_DIR.tar.gz"

    LSINSTALL_DIR="${WGET_TEMP}/${LOCAL_DIR}"
    if [ -e "${LSINSTALL_DIR}" ]; then
        /bin/rm -rf "${LSINSTALL_DIR}"
    fi

    tar -zxf "$WGET_TEMP/$LOCAL_DIR.tar.gz"
    check_errs $? "Could not extract $LOCAL_DIR.tar.gz"

    if [ "$SERIAL" = "TRIAL" ]; then
        wget -q --output-document=${LSINSTALL_DIR}/trial.key http://license.litespeedtech.com/reseller/trial.key
    else
        echo "$SERIAL" > "${LSINSTALL_DIR}/serial.no"
    fi

    echo ""

    echo "Prepare Installing ..."

    echo "
    LSWS_HOME=$LSWS_HOME
    AP_PORT_OFFSET=$AP_PORT_OFFSET
    PHP_SUEXEC=$PHP_SUEXEC
    ADMIN_USER=$ADMIN_USER
    "

    cd "${LSINSTALL_DIR}"

    source ./functions.sh 2>/dev/null
    if [ $? != 0 ]; then
        . ./functions.sh
        check_errs $? "Can not include 'functions.sh'."
    fi


    init

    # below variable has to be set after init
    INSTALL_TYPE="reinstall"
    ADMIN_EMAIL="$ADMIN_EMAIL_INPUT"
    PHP_SUEXEC="$PHP_SUEXEC_INPUT"
    PHP_SUFFIX=php
    SETUP_PHP=1
    ADMIN_PORT=7080
    DEFAULT_PORT=8088
    WS_USER=nobody
    WS_GROUP=nobody


    if [ 'x$ADMIN_USER' != 'x' ] && [ 'x$PASS_ONE' != 'x' ]; then
        ENCRYPT_PASS=`"$LSINSTALL_DIR/admin/fcgi-bin/admin_php5" -q "$LSINSTALL_DIR/admin/misc/htpasswd.php" $ADMIN_PASS`
        echo "$ADMIN_USER:$ENCRYPT_PASS" > "$LSINSTALL_DIR/admin/conf/htpasswd"
    fi

#    configRuby

    if [ ! -e "$LSWS_HOME" ]; then
        mkdir  "$LSWS_HOME"
    fi

#    test_license

    echo ""
    echo "Installing LiteSpeed web server, please wait... "
    echo ""
#build with apache config files
#   buildAPConfigFiles 

    buildConfigFiles
    installation

#    installLicense

    echo ""
#    $LSWS_HOME/admin/misc/rc-inst.sh

#    $LSWS_HOME/admin/misc/fix_cagefs.sh
}

download_lsws

install_lsws


echo ""
echo "**LITESPEED AUTOINSTALLER COMPLETE**"

