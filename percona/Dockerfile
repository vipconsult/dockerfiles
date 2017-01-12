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

RUN wget https://repo.percona.com/apt/percona-release_0.1-4.jessie_all.deb  --no-check-certificate
RUN dpkg -i percona-release_0.1-4.jessie_all.deb
RUN apt-get update \ 
&& apt-get install percona-xtradb-cluster-full-57
