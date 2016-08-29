FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>


RUN apt-get install \
        cron \
        nano  \
        supervisor \
        ssmtp \
        rsyslog &&\
    rm -rf /var/lib/apt/lists/* && apt-get clean
    
ADD supervisord.conf /etc/supervisor/conf.d/
ADD entrypoint.sh entrypoint.sh
RUN chmod u+x /entrypoint.sh  \
    && sed -i -e 's/\r$//' /entrypoint.sh
CMD /usr/bin/supervisord