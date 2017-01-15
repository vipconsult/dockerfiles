FROM debian:jessie
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>
ENV DEBIAN_FRONTEND noninteractive 
ENV APT_LISTCHANGES_FRONTEND noninteractive

RUN echo 'APT::NeverAutoRemove "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Update::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo deb http://bacula.org/downloads/baculum/debian jessie main >> /etc/apt/sources.list && \
    echo deb-src http://bacula.org/downloads/baculum/debian jessie main >> /etc/apt/sources.list && \
#
    apt-get update && \
    apt-get install wget sudo nano && \
    echo Defaults:www-data      !requiretty >> /etc/sudoers && \
    echo www-data       ALL= NOPASSWD:  /usr/sbin/bconsole >> /etc/sudoers && \
    echo www-data       ALL= NOPASSWD:  /etc/bacula/bconsole >> /etc/sudoers && \
    wget -qO - http://bacula.org/downloads/baculum/baculum.pub | apt-key add - && \
    apt-get install baculum baculum-apache2 && \
    ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && \
    ln -s /etc/apache2/sites-available/baculum.conf /etc/apache2/sites-enabled/baculum.conf && \
    apt-get purge wget && \
    apt-get autoremove && \
    apt-get clean      
ADD bconsole.conf /tmp/
ADD settings.conf /etc/baculum/Data-apache/
ADD libs/ /tmp/lib
ADD run.sh /tmp
RUN chmod +x /tmp/run.sh
CMD ["/bin/bash", "-c", "/tmp/run.sh"]
