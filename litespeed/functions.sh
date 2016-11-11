#!/bin/sh


init()
{
    LSINSTALL_DIR=`pwd`
    VERSION=`cat VERSION`

    export LSINSTALL_DIR

    DIR_MOD=755
    SDIR_MOD=700
    EXEC_MOD=555
    CONF_MOD=600
    DOC_MOD=644

    INST_USER=`id`
    INST_USER=`expr "$INST_USER" : 'uid=.*(\(.*\)) gid=.*'`

    SYS_NAME=`uname -s`
    if [ "x$SYS_NAME" = "xFreeBSD" ] || [ "x$SYS_NAME" = "xNetBSD" ] || [ "x$SYS_NAME" = "xDarwin" ] ; then
        PS_CMD="ps -ax"
        ID_GROUPS="id"
        TEST_BIN="/bin/test"
        ROOTGROUP="wheel"
    else
        PS_CMD="ps -ef"
        ID_GROUPS="id -a"
        TEST_BIN="/usr/bin/test"
        ROOTGROUP="root"
    fi
    SETUP_PHP=0
    SET_LOGIN=0
    ADMIN_PORT=7080
    INSTALL_TYPE="upgrade"
    SERVER_NAME=`uname -n`
    ADMIN_EMAIL="root@localhost"
    AP_PORT_OFFSET=2000
    PHP_SUEXEC=2

    WS_USER=nobody
    WS_GROUP=nobody

    DIR_OWN="nobody:nobody"
    CONF_OWN="nobody:nobody"

    BUILD_ROOT="$LSWS_HOME/../../../"
    WHM_CGIDIR="$BUILD_ROOT/usr/local/cpanel/whostmgr/docroot/cgi"
    if [ -d "$WHM_CGIDIR" ] ; then
        HOST_PANEL="cpanel"
    fi

}


readCurrentConfig()
{
    OLD_USER_CONF=`grep "<user>" "$LSWS_HOME/conf/httpd_config.xml"`
    OLD_GROUP_CONF=`grep "<group>" "$LSWS_HOME/conf/httpd_config.xml"`
    OLD_USER=`expr "$OLD_USER_CONF" : '.*<user>\(.*\)</user>.*'`
    OLD_GROUP=`expr "$OLD_GROUP_CONF" : '.*<group>\(.*\)</group>.*'`
    if [ "x$OLD_USER" != "x" ]; then
        WS_USER=$OLD_USER
    fi
    if [ "x$OLD_GROUP" != "x" ]; then
        WS_GROUP=$OLD_GROUP
    else
        D_GROUP=`$ID_GROUPS $WS_USER`
        WS_GROUP=`expr "$D_GROUP" : '.*gid=[0-9]*(\(.*\)) groups=.*'`
    fi
    DIR_OWN=$WS_USER:$WS_GROUP
    CONF_OWN=$WS_USER:$WS_GROUP

}




# Get destination directory
install_dir()
{
    DEST_RECOM="/usr/local/lsws"
    WS_USER="nobody"
    TMP_DEST=$DEST_RECOM
    LSWS_HOME=$TMP_DEST

   INSTALL_TYPE="upgrade"
   SET_LOGIN=0
    export LSWS_HOME

    if [ -f "$LSWS_HOME/conf/httpd_config.xml" ]; then
        readCurrentConfig
    else
        INSTALL_TYPE="reinstall"
    fi


    DIR_OWN=$WS_USER:$WS_GROUP
    CONF_OWN=$WS_USER:$WS_GROUP

    chmod $DIR_MOD "$LSWS_HOME"
}


admin_login()
{
    ADMIN_USER=admin

# generate password file

        ENCRYPT_PASS=`"$LSINSTALL_DIR/admin/fcgi-bin/admin_php5" -q "$LSINSTALL_DIR/admin/misc/htpasswd.php" 123456`
        echo "$ADMIN_USER:$ENCRYPT_PASS" > "$LSINSTALL_DIR/admin/conf/htpasswd"
}


getUserGroup()
{

            TMP_USER=$WS_USER
            USER_INFO=`id $TMP_USER 2>/dev/null`
            TST_USER=`expr "$USER_INFO" : 'uid=.*(\(.*\)) gid=.*'`
            USER_ID=`expr "$USER_INFO" : 'uid=\(.*\)(.*) gid=.*'`

# get group name
    SUCC=0
    TMP_GROUPS=`groups $WS_USER`
    TST_GROUPS=`expr "$TMP_GROUPS" : '.*:\(.*\)'`
     TST_GROUPS=$TMP_GROUPS

    D_GROUP=`$ID_GROUPS $WS_USER`
    D_GROUP=`expr "$D_GROUP" : '.*gid=[0-9]*(\(.*\)) groups=.*'`
            TMP_GROUP=$D_GROUP
            WS_GROUP=$TMP_GROUP

    DIR_OWN=$WS_USER:$WS_GROUP
    CONF_OWN=$WS_USER:$WS_GROUP

}

stopLshttpd()
{
    RUNNING_PROCESS=`$PS_CMD | grep lshttpd | grep -v grep`
    if [ "x$RUNNING_PROCESS" != "x" ]; then
        cat <<EOF
LiteSpeed web server is running, in order to continue installation, the server
must be stopped.

EOF
        printf "Would you like to stop it now? [Y]"
	 $LSINSTALL_DIR/bin/lswsctrl stop            
            sleep 1
            RUNNING_PROCESS=`$PS_CMD | grep lshttpd | grep -v grep`
            if [ "x$RUNNING_PROCESS" != "x" ]; then
                echo "Failed to stop server, abort installation!"
                exit 1
            fi
fi
}


# get normal TCP port
getServerPort()
{
    DEFAULT_PORT=80
    TMP_PORT=$DEFAULT_PORT
    HTTP_PORT=$TMP_PORT
}


# get administration TCP port
getAdminPort()
{
    DEFAULT_PORT=7080
            TMP_PORT=$DEFAULT_PORT
    ADMIN_PORT=$TMP_PORT
}

configAdminEmail()
{
            ADMIN_EMAIL=root@localhost
}

configRuby()
{

    if [ -x "/usr/local/bin/ruby" ]; then
        RUBY_PATH="\/usr\/local\/bin\/ruby"
    elif [ -x "/usr/bin/ruby" ]; then
        RUBY_PATH="\/usr\/bin\/ruby"
    else
        RUBY_PATH=""
        cat << EOF
Cannot find RUBY installation, remember to fix up the ruby path configuration
before you can use our easy RubyOnRails setup.

EOF
    fi
}

enablePHPHandler()
{
            SETUP_PHP=0
}


buildApConfigFiles()
{
    sed -e "s/%ADMIN_PORT%/$ADMIN_PORT/" "$LSINSTALL_DIR/admin/conf/admin_config.xml.in" > "$LSINSTALL_DIR/admin/conf/admin_config.xml"
    sed -e "s/%USER%/$WS_USER/" -e "s/%GROUP%/$WS_GROUP/" -e "s#%APACHE_PID_FILE%#$APACHE_PID_FILE#" -e "s/%ADMIN_EMAIL%/$ADMIN_EMAIL/" -e "s#%RUBY_BIN%#$RUBY_PATH#" -e "s/%SERVER_NAME%/$SERVER_NAME/" -e "s/%AP_PORT_OFFSET%/$AP_PORT_OFFSET/" -e "s/%PHP_SUEXEC%/$PHP_SUEXEC/" "$LSINSTALL_DIR/add-ons/$HOST_PANEL/httpd_config.xml${PANEL_VARY}" > "$LSINSTALL_DIR/conf/httpd_config.xml"
}

# generate configuration from template

buildConfigFiles()
{

#sed -e "s/%ADMIN_PORT%/$ADMIN_PORT/" -e "s/%PHP_FCGI_PORT%/$ADMIN_PHP_PORT/" "$LSINSTALL_DIR/admin/conf/admin_config.xml.in" > "$LSINSTALL_DIR/admin/conf/admin_config.xml"

    sed -e "s/%ADMIN_PORT%/$ADMIN_PORT/" "$LSINSTALL_DIR/admin/conf/admin_config.xml.in" > "$LSINSTALL_DIR/admin/conf/admin_config.xml"

    sed -e "s/%USER%/$WS_USER/" -e "s/%GROUP%/$WS_GROUP/" -e "s/%ADMIN_EMAIL%/$ADMIN_EMAIL/" -e "s/%HTTP_PORT%/$HTTP_PORT/" -e  "s/%RUBY_BIN%/$RUBY_PATH/" -e "s/%SERVER_NAME%/$SERVER_NAME/" "$LSINSTALL_DIR/conf/httpd_config.xml.in" > "$LSINSTALL_DIR/conf/httpd_config.xml.tmp"

    if [ $SETUP_PHP -eq 1 ]; then
        sed -e "s/%PHP_BEGIN%//" -e "s/%PHP_END%//" -e "s/%PHP_SUFFIX%/$PHP_SUFFIX/" -e "s/%PHP_PORT%/$PHP_PORT/" "$LSINSTALL_DIR/conf/httpd_config.xml.tmp" > "$LSINSTALL_DIR/conf/httpd_config.xml"
    else
        sed -e "s/%PHP_BEGIN%/<!--/" -e "s/%PHP_END%/-->/" -e "s/%PHP_SUFFIX%/php/" -e "s/%PHP_PORT%/5201/" "$LSINSTALL_DIR/conf/httpd_config.xml.tmp" > "$LSINSTALL_DIR/conf/httpd_config.xml"
    fi

}

util_mkdir()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    for arg
      do
      if [ ! -d "$LSWS_HOME/$arg" ]; then
          mkdir "$LSWS_HOME/$arg"
      fi
      chown "$OWNER" "$LSWS_HOME/$arg"
      chmod $PERM  "$LSWS_HOME/$arg"
    done

}


util_cpfile()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    for arg
      do
      cp -f "$LSINSTALL_DIR/$arg" "$LSWS_HOME/$arg"
      chown "$OWNER" "$LSWS_HOME/$arg"
      chmod $PERM  "$LSWS_HOME/$arg"
    done

}

util_ccpfile()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    for arg
      do
      if [ ! -f "$LSWS_HOME/$arg" ]; then
          cp "$LSINSTALL_DIR/$arg" "$LSWS_HOME/$arg"
      fi
      chown "$OWNER" "$LSWS_HOME/$arg"
      chmod $PERM  "$LSWS_HOME/$arg"
    done
}


util_cpdir()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    for arg
      do
      cp -R "$LSINSTALL_DIR/$arg/"* "$LSWS_HOME/$arg/"
      chown -R "$OWNER" "$LSWS_HOME/$arg/"*
    done
}



util_cpdirv()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    VERSION=$1
    shift
    for arg
      do
      cp -R "$LSINSTALL_DIR/$arg/"* "$LSWS_HOME/$arg.$VERSION/"
      chown -R "$OWNER" "$LSWS_HOME/$arg.$VERSION"
      $TEST_BIN -L "$LSWS_HOME/$arg"
      if [ $? -eq 0 ]; then
          rm -f "$LSWS_HOME/$arg"
      fi
      FILENAME=`basename $arg`
      ln -sf "./$FILENAME.$VERSION/" "$LSWS_HOME/$arg"
    done
}

util_cpfilev()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    VERSION=$1
    shift
    for arg
      do
      cp -f "$LSINSTALL_DIR/$arg" "$LSWS_HOME/$arg.$VERSION"
      chown "$OWNER" "$LSWS_HOME/$arg.$VERSION"
      chmod $PERM  "$LSWS_HOME/$arg.$VERSION"
      $TEST_BIN -L "$LSWS_HOME/$arg"
      if [ $? -eq 0 ]; then
          rm -f "$LSWS_HOME/$arg"
      fi
      FILENAME=`basename $arg`
      ln -sf "./$FILENAME.$VERSION" "$LSWS_HOME/$arg"
    done
}


installation1()
{
    umask 022
    if [ $INST_USER = "root" ]; then
        SDIR_OWN="root:$ROOTGROUP"
        chown $SDIR_OWN $LSWS_HOME
    else
        SDIR_OWN=$DIR_OWN
    fi
    sed "s:%LSWS_CTRL%:$LSWS_HOME/bin/lswsctrl:" "$LSINSTALL_DIR/admin/misc/lsws.rc.in" > "$LSINSTALL_DIR/admin/misc/lsws.rc"

    OWNER=$1
    PERM=$2
    shift
    shift
    for arg
      do
      if [ ! -f "$LSWS_HOME/$arg" ]; then
          cp "$LSINSTALL_DIR/$arg" "$LSWS_HOME/$arg"
      fi
      chown "$OWNER" "$LSWS_HOME/$arg"
      chmod $PERM  "$LSWS_HOME/$arg"
    done
}


util_cpdir()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    for arg
      do
      cp -R "$LSINSTALL_DIR/$arg/"* "$LSWS_HOME/$arg/"
      chown -R "$OWNER" "$LSWS_HOME/$arg/"*
      #chmod -R $PERM  $LSWS_HOME/$arg/*
    done
}



util_cpdirv()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    VERSION=$1
    shift
    for arg
      do
      cp -R "$LSINSTALL_DIR/$arg/"* "$LSWS_HOME/$arg.$VERSION/"
      chown -R "$OWNER" "$LSWS_HOME/$arg.$VERSION"
      $TEST_BIN -L "$LSWS_HOME/$arg"
      if [ $? -eq 0 ]; then
          rm -f "$LSWS_HOME/$arg"
      fi
      FILENAME=`basename $arg`
      ln -sf "./$FILENAME.$VERSION/" "$LSWS_HOME/$arg"
              #chmod -R $PERM  $LSWS_HOME/$arg/*
    done
}

util_cpfilev()
{
    OWNER=$1
    PERM=$2
    shift
    shift
    VERSION=$1
    shift
    for arg
      do
      cp -f "$LSINSTALL_DIR/$arg" "$LSWS_HOME/$arg.$VERSION"
      chown "$OWNER" "$LSWS_HOME/$arg.$VERSION"
      chmod $PERM  "$LSWS_HOME/$arg.$VERSION"
      $TEST_BIN -L "$LSWS_HOME/$arg"
      if [ $? -eq 0 ]; then
          rm -f "$LSWS_HOME/$arg"
      fi
      FILENAME=`basename $arg`
      ln -sf "./$FILENAME.$VERSION" "$LSWS_HOME/$arg"
    done
}

compress_admin_file()
{
    TMP_DIR=`pwd`
    cd $LSWS_HOME/admin/html
    find . | grep -e '\.js$'  | xargs -n 1 ../misc/gzipStatic.sh 9
    find . | grep -e '\.css$' | xargs -n 1 ../misc/gzipStatic.sh 9
    cd $TMP_DIR
}


create_lsadm_freebsd()
{
    pw group add lsadm
    lsadm_gid=`grep "^lsadm:" /etc/group | awk -F : '{ print $3; }'`
    pw user add -g $lsadm_gid -d / -s /usr/sbin/nologin -n lsadm
    pw usermod lsadm -G $WS_GROUP
}

create_lsadm()
{
    groupadd lsadm
    lsadm_gid=`grep "^lsadm:" /etc/group | awk -F : '{ print $3; }'`
    useradd -g $lsadm_gid -d / -r -s /sbin/nologin lsadm
    usermod -a -G $WS_GROUP lsadm

}

create_lsadm_solaris()
{
    groupadd lsadm
    lsadm_gid=`grep "^lsadm:" /etc/group | awk -F: '{ print $3; }'`
    useradd -g $lsadm_gid -d / -s /bin/false lsadm
    usermod -G $WS_GROUP lsadm


}

fix_cloudlinux_limit()
{
    if [ -d /proc/lve ]; then
        lvectl set-user $WS_USER --unlimited
        lvectl set-user lsadm --unlimited
    fi
}

installation()
{
    umask 022
    if [ $INST_USER = "root" ]; then
        export PATH=/sbin:/usr/sbin:$PATH
        if [ "x$SYS_NAME" = "xLinux" ]; then
            create_lsadm
        elif [ "x$SYS_NAME" = "xFreeBSD" ] || [ "x$SYS_NAME" = "xNetBSD" ]; then
            create_lsadm_freebsd
        elif [ "x$SYS_NAME" = "xSunOS" ]; then
            create_lsadm_solaris
        fi
        grep "^lsadm:" /etc/passwd 1>/dev/null 2>&1
        if [ $? -eq 0 ]; then
            CONF_OWN="lsadm:lsadm"
        fi
        SDIR_OWN="root:$ROOTGROUP"
        chown $SDIR_OWN $LSWS_HOME
    else
        SDIR_OWN=$DIR_OWN
    fi
    sed "s:%LSWS_CTRL%:$LSWS_HOME/bin/lswsctrl:" "$LSINSTALL_DIR/admin/misc/lsws.rc.in" > "$LSINSTALL_DIR/admin/misc/lsws.rc"
    sed "s:%LSWS_CTRL%:$LSWS_HOME/bin/lswsctrl:" "$LSINSTALL_DIR/admin/misc/lsws.rc.gentoo.in" > "$LSINSTALL_DIR/admin/misc/lsws.rc.gentoo"
    sed "s:%LSWS_CTRL%:$LSWS_HOME/bin/lswsctrl:" "$LSINSTALL_DIR/admin/misc/lshttpd.service.in" > "$LSINSTALL_DIR/admin/misc/lshttpd.service"

    if [ -d "$LSWS_HOME/admin/html.$VERSION" ]; then
        rm -rf "$LSWS_HOME/admin/html.$VERSION"
    fi

    util_mkdir "$SDIR_OWN" $DIR_MOD admin bin docs fcgi-bin lib logs admin/logs add-ons share  admin/fcgi-bin admin/html.$VERSION admin/misc
    util_mkdir "$CONF_OWN" $SDIR_MOD conf conf/cert conf/templates admin/conf admin/tmp phpbuild autoupdate
    util_mkdir "$SDIR_OWN" $SDIR_MOD admin/cgid admin/cgid/secret
    util_mkdir "$CONF_OWN" $DIR_MOD admin/htpasswds
    chgrp  $WS_GROUP $LSWS_HOME/admin/tmp $LSWS_HOME/admin/cgid $LSWS_HOME/admin/htpasswds
    chmod  g+x $LSWS_HOME/admin/tmp $LSWS_HOME/admin/cgid $LSWS_HOME/admin/htpasswds
    chown  $CONF_OWN $LSWS_HOME/admin/tmp/sess_* 1>/dev/null 2>&1
    util_mkdir "$SDIR_OWN" $DIR_MOD DEFAULT

    find "$LSWS_HOME/admin/tmp" -type s -atime +1 -delete 2>/dev/null
    if [ $? -ne 0 ]; then
        find "$LSWS_HOME/admin/tmp" -type s -atime +1 2>/dev/null | xargs rm -f
    fi

    find "/tmp/lshttpd" -type s -atime +1 -delete 2>/dev/null
    if [ $? -ne 0 ]; then
        find "/tmp/lshttpd" -type s -atime +1 2>/dev/null | xargs rm -f
    fi

    if [ "x$HOST_PANEL" = "xcpanel" ]; then
        if [ ! -d "$BUILD_ROOT/usr/local/lib/php/autoindex/" ]; then
            mkdir -p $BUILD_ROOT/usr/local/lib/php/autoindex
        fi
        if [ -f "$BUILD_ROOT/usr/local/lib/php/autoindex/default.php" ]; then
            mv -f "$BUILD_ROOT/usr/local/lib/php/autoindex/default.php" "$BUILD_ROOT/usr/local/lib/php/autoindex/default.php.old"
        fi
        cp -R "$LSINSTALL_DIR/share/autoindex/"* $BUILD_ROOT/usr/local/lib/php/autoindex/
        if [ -d "$LSWS_HOME/share/autoindex" ]; then
            rm -rf "$LSWS_HOME/share/autoindex"
        fi
        ln -sf /usr/local/lib/php/autoindex "$LSWS_HOME/share/autoindex"
        if [ -d "$WHM_CGIDIR" ]; then
            install_whm_plugin
        fi
    else
        util_mkdir "$SDIR_OWN" $DIR_MOD share/autoindex
        if [ -f "$LSWS_HOME/share/autoindex/default.php" ]; then
            mv -f "$LSWS_HOME/share/autoindex/default.php" "$LSWS_HOME/share/autoindex/default.php.old"
        fi
        util_cpdir "$SDIR_OWN" $DOC_MOD share/autoindex
        util_cpfile "$SDIR_OWN" $DOC_MOD share/autoindex/default.php
    fi
    util_cpdir "$SDIR_OWN" $DOC_MOD add-ons

    util_ccpfile "$SDIR_OWN" $EXEC_MOD fcgi-bin/lsperld.fpl
    util_cpfile "$SDIR_OWN" $EXEC_MOD fcgi-bin/RackRunner.rb fcgi-bin/RailsRunner.rb  fcgi-bin/RailsRunner.rb.2.3
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/fcgi-bin/admin_php5
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/rc-inst.sh admin/misc/admpass.sh admin/misc/rc-uninst.sh admin/misc/uninstall.sh
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/lsws.rc admin/misc/lshttpd.service admin/misc/lsws.rc.gentoo admin/misc/enable_phpa.sh
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/mgr_ver.sh admin/misc/gzipStatic.sh admin/misc/fp_install.sh
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/create_admin_keypair.sh admin/misc/awstats_install.sh
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/update.sh admin/misc/cleancache.sh admin/misc/cleanlitemage.sh admin/misc/lsup5v2.sh
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/fix_cagefs.sh admin/misc/cp_switch_ws.sh
    ln -sf ./lsup5v2.sh "$LSWS_HOME/admin/misc/lsup.sh"
    util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/ap_lsws.sh.in admin/misc/build_ap_wrapper.sh admin/misc/cpanel_restart_httpd.in
    util_cpfile "$SDIR_OWN" $DOC_MOD admin/misc/gdb-bt admin/misc/htpasswd.php admin/misc/php.ini admin/misc/genjCryptionKeyPair.php admin/misc/purge_cache_byurl.php

    if [ -f "$LSINSTALL_DIR/admin/misc/chroot.sh" ]; then
        util_cpfile "$SDIR_OWN" $EXEC_MOD admin/misc/chroot.sh
    fi


    if [ $SET_LOGIN -eq 1 ]; then
        util_cpfile "$CONF_OWN" $CONF_MOD admin/conf/htpasswd
    else
        util_ccpfile "$CONF_OWN" $CONF_MOD admin/conf/htpasswd
    fi

    if [ ! -f "$LSWS_HOME/admin/htpasswds/status" ]; then
        cp "$LSWS_HOME/admin/conf/htpasswd" "$LSWS_HOME/admin/htpasswds/status"
    fi
    chown  $CONF_OWN "$LSWS_HOME/admin/htpasswds/status"
    chgrp  $WS_GROUP "$LSWS_HOME/admin/htpasswds/status"
    chmod  0640 "$LSWS_HOME/admin/htpasswds/status"

    if [ $INSTALL_TYPE = "upgrade" ]; then
        util_ccpfile "$CONF_OWN" $CONF_MOD admin/conf/admin_config.xml
        util_cpfile "$CONF_OWN" $CONF_MOD admin/conf/php.ini
        util_ccpfile "$CONF_OWN" $CONF_MOD conf/httpd_config.xml conf/mime.properties conf/templates/ccl.xml conf/templates/phpsuexec.xml conf/templates/rails.xml
        util_ccpfile "$CONF_OWN" $CONF_MOD conf/templates/ccl.xml
        $TEST_BIN ! -L "$LSWS_HOME/bin/lshttpd"
        if [ $? -eq 0 ]; then
            mv -f "$LSWS_HOME/bin/lshttpd" "$LSWS_HOME/bin/lshttpd.old"
        fi
        $TEST_BIN ! -L "$LSWS_HOME/bin/lscgid"
        if [ $? -eq 0 ]; then
            mv -f "$LSWS_HOME/bin/lscgid" "$LSWS_HOME/bin/lscgid.old"
        fi
        $TEST_BIN ! -L "$LSWS_HOME/bin/lswsctrl"
        if [ $? -eq 0 ]; then
            mv -f "$LSWS_HOME/bin/lswsctrl" "$LSWS_HOME/bin/lswsctrl.old"
        fi
        $TEST_BIN ! -L "$LSWS_HOME/admin/html"
        if [ $? -eq 0 ]; then
            mv -f "$LSWS_HOME/admin/html" "$LSWS_HOME/admin/html.old"
        fi

        if [ ! -f "$LSWS_HOME/DEFAULT/conf/vhconf.xml" ]; then
            util_mkdir "$CONF_OWN" $DIR_MOD DEFAULT/conf
            util_cpdir "$CONF_OWN" $DOC_MOD DEFAULT/conf
        fi
    else
        util_cpfile "$CONF_OWN" $CONF_MOD admin/conf/admin_config.xml
        util_cpfile "$CONF_OWN" $CONF_MOD conf/templates/ccl.xml conf/templates/phpsuexec.xml conf/templates/rails.xml
        util_cpfile "$CONF_OWN" $CONF_MOD admin/conf/php.ini
        util_cpfile "$CONF_OWN" $CONF_MOD conf/httpd_config.xml conf/mime.properties
        util_mkdir "$CONF_OWN" $DIR_MOD DEFAULT/conf
        util_cpdir "$CONF_OWN" $DOC_MOD DEFAULT/conf
        util_mkdir "$SDIR_OWN" $DIR_MOD DEFAULT/html DEFAULT/cgi-bin
        util_cpdir "$SDIR_OWN" $DOC_MOD DEFAULT/html DEFAULT/cgi-bin
    fi
    if [ $SETUP_PHP -eq 1 ]; then
        if [ ! -s "$LSWS_HOME/fcgi-bin/lsphp" ]; then
            cp -f "$LSWS_HOME/admin/fcgi-bin/admin_php5" "$LSWS_HOME/fcgi-bin/lsphp"
            chown "$SDIR_OWN" "$LSWS_HOME/fcgi-bin/lsphp"
            chmod "$EXEC_MOD" "$LSWS_HOME/fcgi-bin/lsphp"
        fi
        if [ ! -f "$LSWS_HOME/fcgi-bin/lsphp4" ]; then
            ln -sf "./lsphp" "$LSWS_HOME/fcgi-bin/lsphp4"
        fi
        if [ ! -f "$LSWS_HOME/fcgi-bin/lsphp5" ]; then
            ln -sf "./lsphp" "$LSWS_HOME/fcgi-bin/lsphp5"
        fi
        if [ ! -e "/usr/local/bin/lsphp" ]; then
            cp -f "$LSWS_HOME/admin/fcgi-bin/admin_php5" "/usr/local/bin/lsphp"
            chown "$SDIR_OWN" "/usr/local/bin/lsphp"
            chmod "$EXEC_MOD" "/usr/local/bin/lsphp"
        fi
    fi

    chown -R "$CONF_OWN" "$LSWS_HOME/conf/"
    chmod -R o-rwx "$LSWS_HOME/conf/"

    util_mkdir "$DIR_OWN" $SDIR_MOD tmp


    util_mkdir "$DIR_OWN" $DIR_MOD DEFAULT/logs DEFAULT/fcgi-bin
    util_cpdirv "$SDIR_OWN" $DOC_MOD $VERSION admin/html


    util_cpfile "$SDIR_OWN" $EXEC_MOD bin/wswatch.sh
    util_cpfilev "$SDIR_OWN" $EXEC_MOD $VERSION bin/lswsctrl bin/lshttpd bin/lscgid

    ln -sf ./lshttpd.$VERSION $LSWS_HOME/bin/lshttpd
    ln -sf lshttpd $LSWS_HOME/bin/litespeed

    ln -sf lscgid.$VERSION $LSWS_HOME/bin/httpd
    if [ $INST_USER = "root" ]; then
        chmod u+s  "$LSWS_HOME/bin/lscgid.$VERSION"

    fi

    util_cpdir "$SDIR_OWN" $DOC_MOD docs/
    util_cpfile "$SDIR_OWN" $DOC_MOD VERSION LICENSE*

    if [ -f $LSWS_HOME/autoupdate/download ]; then
        rm $LSWS_HOME/autoupdate/download
    fi

    #compress_admin_file

    if [ ! -f "$LSWS_HOME/admin/conf/jcryption_keypair" ]; then
        $LSWS_HOME/admin/misc/create_admin_keypair.sh
    fi
    chown "$CONF_OWN" "$LSWS_HOME/admin/conf/jcryption_keypair"
    chmod 0600 "$LSWS_HOME/admin/conf/jcryption_keypair"

    fix_cloudlinux_limit

    if [ $INST_USER = "root" ]; then
        $LSWS_HOME/admin/misc/rc-inst.sh
    fi
}

finish()
{

                $LSWS_HOME/admin/misc/rc-inst.sh




        if [ $INSTALL_TYPE != "upgrade" ]; then
            "$LSWS_HOME/bin/lswsctrl" start
        else
            "$LSWS_HOME/bin/lswsctrl" restart
        fi

    sleep 1
    RUNNING_PROCESS=`$PS_CMD | grep lshttpd | grep -v grep`

    if [ "x$RUNNING_PROCESS" != "x" ]; then

        cat <<EOF

LiteSpeed Web Server started successfully! Have fun!

EOF
        exit 0
    else

        cat <<EOF

[ERROR] Failed to start the web server. For trouble shooting information,
        please refer to documents in "$LSWS_HOME/docs/".

EOF
    fi

}

