#!/bin/bash


iniFile="/usr/local/etc/php/php.ini"
fpmFile="/usr/local/etc/php-fpm.conf"


## global settings

sed -i -e "s/^.*mailhub=.*$/mailhub=$SMTP_SERVER/" /etc/ssmtp/ssmtp.conf


if [ -n "${PHP5_cookie_lifetime}" ]; then
    sed -i -e "s/.*session.cookie_lifetime =.*/session.cookie_lifetime = $PHP5_cookie_lifetime/" $iniFile
else
    sed -i -e "s/.*session.cookie_lifetime =.*/session.cookie_lifetime = 315360000/" $iniFile
fi

if [ -n "${PHP5_memory_limit}" ]; then
    sed -i -e "s/.*memory_limit =.*/memory_limit = $PHP5_memory_limit/" $iniFile
else
    sed -i -e "s/.*memory_limit =.*/memory_limit = 1024M/" $iniFile
fi

if [ -n "${PHP5_post_max_size}" ]; then
    sed -i -e "s/.*post_max_size =.*/post_max_size = $PHP5_post_max_size/" $iniFile  
else
    sed -i -e "s/.*post_max_size =.*/post_max_size = 500M/" $iniFile  
fi

if [ -n "${PHP5_max_input_vars}" ]; then
    sed -i -e "s/.*max_input_vars =.*/max_input_vars = $PHP5_max_input_vars/" $iniFile  
else
    sed -i -e "s/.*max_input_vars =.*/max_input_vars = 5000/" $iniFile  
fi

if [ -n "${PHP5_error_reporting}" ]; then
    sed -i -e "s/.*error_reporting =.*/error_reporting = $PHP5_error_reporting/" $iniFile  
else
    sed -i -e "s/.*error_reporting =.*/error_reporting = E_ALL \& ~E_DEPRECATED/" $iniFile  
fi

if [ -n "${PHP5_display_errors}" ]; then
    sed -i -e "s/.*display_errors =.*/display_errors = $PHP5_display_errors/" $iniFile  
else
    sed -i -e "s/.*display_errors =.*/display_errors = off/" $iniFile  
fi

if [ -n "${PHP5_upload_max_filesize}" ]; then
    sed -i -e "s/.*upload_max_filesize =.*/upload_max_filesize = $PHP5_upload_max_filesize/" $iniFile  
else
    sed -i -e "s/.*upload_max_filesize =.*/upload_max_filesize = 500M/" $iniFile  
fi

if [ -n "${PHP5_max_execution_time}" ]; then
    sed -i -e "s/.*max_execution_time =.*/max_execution_time = $PHP5_max_execution_time/" $iniFile  
else
    sed -i -e "s/.*max_execuiont_time =.*/max_execution_time = 300/" $iniFile  
fi

if [ -n "${PHP5_default_socket_timeout}" ]; then
    sed -i -e "s/.*default_socket_timeout =.*/default_socket_timeout = $PHP5_default_socket_timeout/" $iniFile  
else
    sed -i -e "s/.*default_socket_timeout =.*/default_socket_timeout = 120/" $iniFile  
fi

if [ -n "${PHP5_date_timezone}" ]; then
    sed -i -e "s/.*date.timezone =.*/date.timezone = $PHP5_date_timezone/" $iniFile
else
    sed -i -e "s/.*date.timezone =.*/date.timezone = Europe\/London/" $iniFile
fi


## process manager settings

## add all params because the default file might not have all these included.

params="clear_env group user pm pm.max_children pm.start_servers pm.min_spare_servers pm.max_spare_servers pm.process_idle_timeout"

for p in $params; do
    if ! grep -lq "$p =" $fpmFile   ; then
        printf  "\n;$p = " >> $fpmFile
    fi
done

sed -i -e "s/.*clear_env =.*/clear_env = no/" $fpmFile

if [ -n "${PHP5_user}" ]; then
    sed -i -e "s/.*user =.*/user = $PHP5_user/" $fpmFile
else
    sed -i -e "s/.*user =.*/user = nobody/" $fpmFile
fi

if [ -n "${PHP5_group}" ]; then
    sed -i -e "s/.*group =.*/group = $PHP5_group/" $fpmFile
else
    sed -i -e "s/.*group =.*/group = nogroup/" $fpmFile
fi

if [ -n "${PHP5_port}" ]; then
    sed -i -e "s/.*listen =.*/listen = 0.0.0.0:$PHP5_port/" $fpmFile
else
    sed -i -e "s/.*listen =.*/listen = 0.0.0.0:9000/" $fpmFile
fi

if [ -n "${PHP5_pm}" ]; then
    sed -i -e "s/.*pm =.*/pm = $PHP5_pm/" $fpmFile
fi
if [ -n "${PHP5_max_children}" ]; then
    sed -i -e "s/.*pm.max_children =.*/pm.max_children = $PHP5_max_children/" $fpmFile
fi
if [ -n "${PHP5_start_servers}" ]; then
    sed -i -e "s/.*pm.start_servers =.*/pm.start_servers = $PHP5_start_servers/" $fpmFile
fi
if [ -n "${PHP5_min_spare_servers}" ]; then
    sed -i -e "s/.*pm.min_spare_servers =.*/pm.min_spare_servers = $PHP5_min_spare_servers/" $fpmFile
fi
if [ -n "${PHP5_max_spare_servers}" ]; then
    sed -i -e "s/.*pm.max_spare_servers =.*/pm.max_spare_servers = $PHP5_max_spare_servers/" $fpmFile
fi
if [ -n "${PHP5_process_idle_timeout}" ]; then
    sed -i -e "s/.*pm.process_idle_timeout =.*/pm.process_idle_timeout = $PHP5_process_idle_timeout/" $fpmFile
fi

php-fpm