FROM vipconsult/base:jessie
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

RUN apt-get install exim4 supervisor &&  \
    rm -rf /var/lib/apt/lists/* && apt-get clean
        
ADD update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf
ADD supervisord.conf /etc/supervisor/conf.d/
ADD entrypoint.sh /entrypoint.sh 
RUN chmod 777 /entrypoint.sh  \
    && sed -i -e 's/\r$//' /entrypoint.sh

CMD ["/usr/bin/supervisord"]
