FROM debian:latest

MAINTAINER Stan Velikov "stan@vip-consult.solutions"

ENV OpenLiteSpeed 1.4.17-2 ~ trusty
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

RUN apt-get update && apt-get -y upgrade && apt-get install wget openssl
RUN apt-get install build-essential  lib32z1 # lib32ncurses5	#da moje se compilira php i da startira instalaciqta na litespeed
#RUN wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash \
#&& apt-get -y update

#RUN ln -sf /usr/local/lsws/lsphp56/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5 

RUN mkdir -p /var/log/litespeed
RUN groupadd -g 1001 lsadm
RUN useradd -d /dev/null -s /usr/sbin/nologin -g lsadm -u 999 lsadm
RUN chown -R lsadm:lsadm /var/log/litespeed
RUN mkdir -p /usr/local/lsws
RUN chmod 777 /usr/local/lsws
ADD lsws-5.0.19-std-i386-linux.tar.gz/ /usr/local/lsws/
#RUN cp -av /usr/local/lsws-5.0.19/* /usr/local/lsws/
#RUN rm -rf /usr/local/lsws/admin/tmp
#RUN ln -s /tmp /usr/local/lsws/admin/tmp
ADD install.sh  /usr/local/lsws/lsws-5.0.19/
ADD functions.sh  /usr/local/lsws/lsws-5.0.19/
RUN chmod 777 /usr/local/lsws/lsws-5.0.19/functions.sh
RUN chmod 777 /usr/local/lsws/lsws-5.0.19/install.sh
#VOLUME /usr/local/lsws/conf

EXPOSE 80 7080 443 8088

CMD ["sh", "-c", "/usr/local/lsws/lsws-5.0.19/install.sh" ]
