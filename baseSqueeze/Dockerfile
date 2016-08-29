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
    echo 'deb http://snapshot.debian.org/archive/debian/20160301T101045Z/ squeeze main non-free contrib' > /etc/apt/sources.list && \
    echo 'deb http://snapshot.debian.org/archive/debian-backports/20160301T101045Z/ squeeze-backports main non-free contrib' >> /etc/apt/sources.list && \
    
    apt-get -o Acquire::Check-Valid-Until=false update && apt-get install \
        wget && \
    echo 'deb http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    echo 'deb-src http://packages.dotdeb.org squeeze all' >> /etc/apt/sources.list && \
    wget -O - http://www.dotdeb.org/dotdeb.gpg |apt-key add -  && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install linux-libc-dev && \
    wget http://snapshot.debian.org/archive/debian/20160216T165545Z/pool/main/e/eglibc/libc-dev-bin_2.11.3-4%2Bdeb6u11_amd64.deb && \
    dpkg -i libc-dev-bin_2.11.3-4+deb6u11_amd64.deb && \
    wget http://snapshot.debian.org/archive/debian/20160216T165545Z/pool/main/e/eglibc/libc6-dev_2.11.3-4%2Bdeb6u11_amd64.deb && \
    dpkg -i libc6-dev_2.11.3-4+deb6u11_amd64.deb && \
    rm libc-dev-bin_2.11.3-4+deb6u11_amd64.deb libc6-dev_2.11.3-4+deb6u11_amd64.deb && \
    apt-get  upgrade  && \
    apt-get install \
    nano \
    procps && \
    apt-get autoremove

ONBUILD RUN apt-get -o Acquire::Check-Valid-Until=false update