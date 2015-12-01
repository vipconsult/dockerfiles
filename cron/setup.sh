#!/bin/bash
cronFile=/etc/crontab

echo "SHELL=/bin/sh" >$cronFile
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >>$cronFile

grep -q "MAILTO=$CRON_EMAIL" $cronFile || {
    echo "MAILTO=$CRON_EMAIL" >> $cronFile


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
}

