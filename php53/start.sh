#!/bin/bash

env | sed "s/\(.*\)=\(.*\)/env[\1]='\2'/" >> /etc/php5/fpm/pool.d/www.conf

sed -i -e "s/^.*mailhub=.*$/mailhub=$SMTP_SERVER/" /etc/ssmtp/ssmtp.conf

## global settings
if [ -n "${PHP53_cookie_lifetime}" ]; then
    sed -i -e "s/;\?session.cookie_lifetime =.*/session.cookie_lifetime = $PHP53_cookie_lifetime/" /etc/php5/fpm/php.ini
else
    sed -i -e "s/;\?session.cookie_lifetime =.*/session.cookie_lifetime = 315360000/" /etc/php5/fpm/php.ini
fi

if [ -n "${PHP53_memory_limit}" ]; then
    sed -i -e "s/;\?memory_limit =.*/memory_limit = $PHP53_memory_limit/" /etc/php5/fpm/php.ini
else
    sed -i -e "s/;\?memory_limit =.*/memory_limit = 1024M/" /etc/php5/fpm/php.ini
fi

if [ -n "${PHP53_post_max_size}" ]; then
    sed -i -e "s/;\?post_max_size =.*/post_max_size = $PHP53_post_max_size/" /etc/php5/fpm/php.ini  
else
    sed -i -e "s/;\?post_max_size =.*/post_max_size = 128M/" /etc/php5/fpm/php.ini  
fi

if [ -n "${PHP53_max_input_vars}" ]; then
    sed -i -e "s/;\?max_input_vars =.*/max_input_vars = $PHP53_max_input_vars/" /etc/php5/fpm/php.ini  
else
    sed -i -e "s/;\?max_input_vars =.*/max_input_vars = 1000/" /etc/php5/fpm/php.ini  
fi

if [ -n "${PHP53_error_reporting}" ]; then
    sed -i -e "s/;\?error_reporting =.*/error_reporting = $PHP53_error_reporting/" /etc/php5/fpm/php.ini  
else
    sed -i -e "s/;\?error_reporting =.*/error_reporting = E_ALL \& ~E_DEPRECATED/" /etc/php5/fpm/php.ini  
fi

if [ -n "${PHP53_display_errors}" ]; then
    sed -i -e "s/;\?display_errors =.*/display_errors = $PHP53_display_errors/" /etc/php5/fpm/php.ini  
else
    sed -i -e "s/;\?display_errors =.*/display_errors = off/" /etc/php5/fpm/php.ini  
fi

if [ -n "${PHP53_upload_max_filesize}" ]; then
    sed -i -e "s/;\?upload_max_filesize =.*/upload_max_filesize = $PHP53_upload_max_filesize/" /etc/php5/fpm/php.ini  
else
    sed -i -e "s/;\?upload_max_filesize =.*/upload_max_filesize = 500M/" /etc/php5/fpm/php.ini  
fi

if [ -n "${PHP53_max_execution_time}" ]; then
    sed -i -e "s/;\?max_execution_time =.*/max_execution_time = $PHP53_max_execution_time/" /etc/php5/fpm/php.ini  
else
    sed -i -e "s/;\?max_execuiont_time =.*/max_execution_time = 300/" /etc/php5/fpm/php.ini  
fi

if [ -n "${PHP53_default_socket_timeout}" ]; then
    sed -i -e "s/;\?default_socket_timeout =.*/default_socket_timeout = $PHP53_default_socket_timeout/" /etc/php5/fpm/php.ini  
else
    sed -i -e "s/;\?default_socket_timeout =.*/default_socket_timeout = 120/" /etc/php5/fpm/php.ini  
fi

if [ -n "${PHP53_date_timezone}" ]; then
    sed -i -e "s/;\?date.timezone =.*/date.timezone = $PHP53_date_timezone/" /etc/php5/fpm/php.ini
    sed -i -e "s/;\?date.timezone =.*/date.timezone = $PHP53_date_timezone/" /etc/php5/cli/php.ini
else
    sed -i -e "s/;\?date.timezone =.*/date.timezone = Europe\/London/" /etc/php5/fpm/php.ini
    sed -i -e "s/;\?date.timezone =.*/date.timezone = Europe\/London/" /etc/php5/cli/php.ini
fi

if [ -n "${PHP53_user}" ]; then
    sed -i -e "s/;\?user =.*/user = $PHP53_user/" /etc/php5/fpm/pool.d/www.conf
    sed -i -e "s/;\?listen.owner = .*/listen.owner = $PHP53_user/" /etc/php5/fpm/pool.d/www.conf
else
    sed -i -e "s/;\?user =.*/user = nobody/" /etc/php5/fpm/pool.d/www.conf
    sed -i -e "s/;\?listen.owner = .*/listen.owner = nobody/" /etc/php5/fpm/pool.d/www.conf
fi

if [ -n "${PHP53_group}" ]; then
    sed -i -e "s/;\?group =.*/group = $PHP53_group/" /etc/php5/fpm/pool.d/www.conf
    sed -i -e "s/;\?listen.group = .*/listen.group = $PHP53_group/" /etc/php5/fpm/pool.d/www.conf
else
    sed -i -e "s/;\?group =.*/group = nogroup/" /etc/php5/fpm/pool.d/www.conf
    sed -i -e "s/;\?listen.group = .*/listen.group = nogroup/" /etc/php5/fpm/pool.d/www.conf
fi

## process manager settings

if [ -n "${PHP53_run_file}" ]; then
    sed -i -e "s/;\?listen =.*/listen = \/var\/run\/$PHP53_run_file.sock/" /etc/php5/fpm/pool.d/www.conf
    sed -i -e "s/;\?pid =.*/pid = \/var\/run\/$PHP53_run_file.pid/" /etc/php5/fpm/php-fpm.conf
else
    sed -i -e "s/;\?listen =.*/listen = \/var\/run\/php53-fpm.sock/" /etc/php5/fpm/pool.d/www.conf
    sed -i -e "s/;\?pid =.*/pid = \/var\/run\/php53-fpm.pid/" /etc/php5/fpm/php-fpm.conf
fi

if [ -n "${PHP53_pm}" ]; then
    sed -i -e "s/;\?pm =.*/pm = $PHP53_pm/" /etc/php5/fpm/pool.d/www.conf
fi
if [ -n "${PHP53_max_children}" ]; then
    sed -i -e "s/;\?pm.max_children =.*/pm.max_children = $PHP53_max_children/" /etc/php5/fpm/pool.d/www.conf
fi
if [ -n "${PHP53_start_servers}" ]; then
    sed -i -e "s/;\?pm.start_servers =.*/pm.start_servers = $PHP53_start_servers/" /etc/php5/fpm/pool.d/www.conf
fi
if [ -n "${PHP53_min_spare_servers}" ]; then
    sed -i -e "s/;\?pm.min_spare_servers =.*/pm.min_spare_servers = $PHP53_min_spare_servers/" /etc/php5/fpm/pool.d/www.conf
fi
if [ -n "${PHP53_max_spare_servers}" ]; then
    sed -i -e "s/;\?pm.max_spare_servers =.*/pm.max_spare_servers = $PHP53_max_spare_servers/" /etc/php5/fpm/pool.d/www.conf
fi
if [ -n "${PHP53_process_idle_timeout}" ]; then
    sed -i -e "s/;\?pm.process_idle_timeout =.*/pm.process_idle_timeout = $PHP53_process_idle_timeout/" /etc/php5/fpm/pool.d/www.conf
fi

/usr/sbin/php5-fpm -c /etc/php5/fpm