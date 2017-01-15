FROM vipconsult/base:jessie
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>


RUN apt-get update && apt-get install apt-transport-https ca-certificates && \
	echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list && \
	apt-get update && \
	apt-get  install \
		docker-engine \
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
