#!/bin/bash
set -e

cronFile=/etc/crontab

echo "SHELL=/bin/sh" >$cronFile
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>$cronFile

if [ -n "${CRON_EMAIL}" ]; then
    echo "MAILTO=$CRON_EMAIL" >> $cronFile
fi

for item in `env`
do
   case "$item" in
       CRONTASK_*)
            ENVVAR=`echo $item | cut -d \= -f 1`
            printenv $ENVVAR >> $cronFile
            ;;
   esac
done

smtpFile=/etc/ssmtp/revaliases
echo "root:cron-$HOSTNAME.$DOMAINNAME@$DOMAINNAME:$SMTP_SERVER" >> $smtpFile

# avoid race condition when crontab is trying to read the crontab file , but the file is still not closed
sleep 1 

exec "$@"

