FROM debian:squeeze
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

    apt-get update && \
    apt-get install \
        wget && \
    echo 'deb http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    echo 'deb-src http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    wget -O - http://www.dotdeb.org/dotdeb.gpg |apt-key add -  && \
    apt-get update && \
    apt-get install \
    nano \
    procps && \
    apt-get autoremove

ONBUILD RUN apt-get update