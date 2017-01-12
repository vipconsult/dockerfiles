FROM vipconsult/base:jessie
MAINTAINER Stan Velikov "stan@vip-consult.solutions"

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive 
ENV APT_LISTCHANGES_FRONTEND noninteractive

RUN echo 'APT::NeverAutoRemove "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Update::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01usersetting  

RUN apt-get update #&& apt-get -y upgrade && apt-get install wget openssl nano
RUN apt-get install build-essential  lib32z1 #required libs for litespeed instalations


RUN mkdir -p /var/log/litespeed
RUN groupadd -g 1001 lsadm \
&& groupadd -g 1002 nobody \
&& useradd -d /dev/null -s /usr/sbin/nologin -g lsadm -u 999 lsadm \
&& chown -R lsadm:lsadm /var/log/litespeed \
&& mkdir -p /usr/local/lsws \
&& chmod 777 /usr/local/lsws 
ADD lsws_install.sh  /usr/local/lsws/
RUN chmod 777 /usr/local/lsws/lsws_install.sh
#VOLUME /usr/local/lsws/conf
RUN bash /usr/local/lsws/lsws_install.sh TRIAL 2 0 admin 123456 root@localhost
EXPOSE 80 7080 443 8088

CMD ["sh", "-c", "/usr/local/lsws/bin/lswsctrl start; tail -F /var/log/litespeed/lsws-error.log /var/log/litespeed/lsws-access.log" ]
