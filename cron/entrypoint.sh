#!/bin/bash
set -e

cronFile=/etc/crontab

echo "SHELL=/bin/sh" >$cronFile
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>$cronFile

# add all env vars to the cron runner
printenv >> $cronFile

# CRONTASK_ vars use a special format so need to be processed separately
for item in `env`
do
   case "$item" in
       CRONTASK_*)
            ENVVAR=`echo $item | cut -d \= -f 1`
            printenv $ENVVAR | sed 's/"\(.*\)"/\1/' >> $cronFile
            ;;
   esac
done

smtpFile=/etc/ssmtp/revaliases
echo "root:cron_$HOSTNAME@$DOMAINNAME:$SMTP_SERVER" >> $smtpFile

# avoid race condition when crontab is trying to read the crontab file , but the file is still not closed
sleep 1 

exec "$@"

