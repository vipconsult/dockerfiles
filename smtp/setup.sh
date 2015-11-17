#! /bin/bash

# run only the first time
grep -q "remote_max_parallel=$SMTP_REMOTE_MAX_PARALLEL" /etc/exim4/exim4.conf.template || {

    # the mailname needs to be set as otherwise all server reject mails form non FQDN
    echo $DOMAINNAME > /etc/mailname

    # these are set here because the debian reconfig doesn't support them

    #limit emails to prevent spam bots sending mass emails
    sed -i "/^.*\/usr\/sbin\/exim4/ a $SMTP_PROCESSING" /etc/exim4/exim4.conf.template

    if [ -n "${SMTP_REMOTE_MAX_PARALLEL}" ]; then
        sed -i "/^.*\/usr\/sbin\/exim4/ a remote_max_parallel=$SMTP_REMOTE_MAX_PARALLEL" /etc/exim4/exim4.conf.template
    fi
    if [ -n "${SMTP_QUEUE_RUN_MAX}" ]; then
        sed -i "/^.*\/usr\/sbin\/exim4/ a queue_run_max=$SMTP_QUEUE_RUN_MAX" /etc/exim4/exim4.conf.template
    fi

    sed -i -e "s/domainlist local_domains = MAIN_LOCAL_DOMAINS/domainlist local_domains =/g" /etc/exim4/exim4.conf.template  && \
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_CANON = relaxed' /etc/exim4/exim4.conf.template && \
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_SELECTOR = default' /etc/exim4/exim4.conf.template && \
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_PRIVATE_KEY = /var/spool/exim4/dkim.main.key' /etc/exim4/exim4.conf.template && \
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_DOMAIN = ${lc:${domain:$h_from:}}' /etc/exim4/exim4.conf.template && \
    sed -i '/^.*\/usr\/sbin\/exim4/ a DKIM_SIGN_HEADERS = true' /etc/exim4/exim4.conf.template
    sed -i "/^.*\/usr\/sbin\/exim4/ a REMOTE_SMTP_HELO_DATA=$DOMAINNAME" /etc/exim4/exim4.conf.template
    ## this will add missing headers to the outgoing messages
    sed -i "/^.*acl_check_rcpt:/ a accept control = submission/sender_retain" /etc/exim4/exim4.conf.template
    ## google postmaster tools - sends reports
    sed -i "/^.*remote_smtp:/ a headers_add = Feedback-ID: CampaignIDX:$DOMAINNAME:MailTypeID3:$DOMAINNAME" /etc/exim4/exim4.conf.template
    update-exim4.conf
}

