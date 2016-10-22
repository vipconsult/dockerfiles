FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>


RUN apt-get install apt-transport-https ca-certificates && \
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
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