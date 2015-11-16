FROM debian:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get update
    
RUN apt-get install -y exim4 --no-install-recommends supervisor 
        
ADD update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf
ADD supervisord.conf /etc/supervisor/conf.d/
ADD setup.sh setup.sh

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

CMD ["/usr/bin/supervisord"]