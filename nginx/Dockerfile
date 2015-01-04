FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list && \
    apt-get -y update

RUN apt-get -t wheezy-backports install -y \
    nginx && \
    usermod -l http www-data && \
    groupmod -n http www-data

#rm -rf /var/lib/apt/lists/* && \
#    apt-get clean

EXPOSE 80
EXPOSE 443

CMD nginx -c $CONFIG -g "daemon off;"

