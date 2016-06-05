#!/bin/bash
set -e

mkdir -p /var/spool/exim4
chmod 777 -R /var/spool/exim4

# run only the first time
grep -q "remote_max_parallel=$SMTP_remote_max_parallel" /etc/exim4/exim4.conf.template || {
    # the mailname needs to be set as otherwise all server reject mails form non FQDN
    echo $DOMAINNAME > /etc/mailname


    sed -i -e "s/.*rfc1413_hosts =.*/rfc1413_hosts =/" /etc/exim4/exim4.conf.template
    sed -i -e "s/.*rfc1413_query_timeout =.*/rfc1413_query_timeout = 0s/" /etc/exim4/exim4.conf.template
    sed -i -e "s/.*dc_minimaldns=.*/dc_minimaldns='true'/" /etc/exim4/update-exim4.conf.conf

    # these are set here because the debian reconfig doesn't support them

    #limit emails to prevent spam bots sending mass emails
    sed -i "/^.*\/usr\/sbin\/exim4/ a $SMTP_PROCESSING" /etc/exim4/exim4.conf.template

    if [ -n "${SMTP_remote_max_parallel}" ]; then
        sed -i "/^.*\/usr\/sbin\/exim4/ a remote_max_parallel=$SMTP_remote_max_parallel" /etc/exim4/exim4.conf.template
    fi
    if [ -n "${SMTP_queue_run_max}" ]; then
        sed -i "/^.*\/usr\/sbin\/exim4/ a queue_run_max=$SMTP_queue_run_max" /etc/exim4/exim4.conf.template
    fi

    if [ -n "${SMTP_timeout_frozen_after}" ]; then
        sed -i -e "s/.*timeout_frozen_after.*/timeout_frozen_after=$SMTP_timeout_frozen_after/" /etc/exim4/exim4.conf.template
    fi

    sed -i -e "s/domainlist local_domains = MAIN_LOCAL_DOMAINS/domainlist local_domains =/g" /etc/exim4/exim4.conf.template  
    sed -i -e "s/freeze_tell = /#freeze_tell =/g" /etc/exim4/exim4.conf.template  
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_CANON = relaxed' /etc/exim4/exim4.conf.template 
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_SELECTOR = default' /etc/exim4/exim4.conf.template 
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_PRIVATE_KEY = /var/spool/exim4/dkim.main.key' /etc/exim4/exim4.conf.template 
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_DOMAIN = ${lc:${domain:$h_from:}}' /etc/exim4/exim4.conf.template
    sed -i "/^.*\/usr\/sbin\/exim4/ a REMOTE_SMTP_HELO_DATA=$DOMAINNAME" /etc/exim4/exim4.conf.template
    ## this will add missing headers to the outgoing messages
    sed -i "/^.*acl_check_rcpt:/ a accept control = submission/sender_retain" /etc/exim4/exim4.conf.template
    ## google postmaster tools - sends reports
    sed -i "/^.*remote_smtp:/ a headers_add = Feedback-ID: CampaignIDX:$DOMAINNAME:MailTypeID3:$DOMAINNAME" /etc/exim4/exim4.conf.template
    
}

# remove all acl rules to speed up the sending
rm -R /etc/exim4/conf.d/acl/*
echo "acl_check_rcpt: "> /etc/exim4/conf.d/acl/30_exim4-config_check_rcpt
echo "  accept" >> /etc/exim4/conf.d/acl/30_exim4-config_check_rcpt
echo "  control = dkim_disable_verify" >> /etc/exim4/conf.d/acl/30_exim4-config_check_rcpt

update-exim4.conf


sleep 0.5;

exec "$@"