FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get update
    
RUN apt-get install -y exim4
        
ADD update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf

# the mailname needs to be set as otherwise all server reject mails form non FQDN
RUN echo vip-consult.co.uk > /etc/mailname && \
    sed -i -e "s/domainlist local_domains = MAIN_LOCAL_DOMAINS/domainlist local_domains =/g" /etc/exim4/exim4.conf.template  && \
    update-exim4.conf

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

CMD ["/usr/sbin/exim", "-bdf","-bm","-q30m"]
