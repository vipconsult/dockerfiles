FROM debian:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive 
ENV APT_LISTCHANGES_FRONTEND noninteractive

RUN echo 'APT::NeverAutoRemove "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Update::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \

    printf "deb http://ftp.uk.debian.org/debian/ jessie main contrib non-free \n \
            deb-src http://ftp.uk.debian.org/debian/ jessie main contrib non-free\n"  \
            >> /etc/apt/sources.list && \
    
    apt-get update && \
    apt-get install \
        nano \
        wget && \
    apt-get autoremove

ONBUILD RUN apt-get update