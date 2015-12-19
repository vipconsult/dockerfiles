FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get install exim4 supervisor &&  \
    rm -rf /var/lib/apt/lists/* && apt-get clean
        
ADD update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf
ADD supervisord.conf /etc/supervisor/conf.d/
ADD entrypoint.sh /entrypoint.sh

CMD ["/usr/bin/supervisord"]