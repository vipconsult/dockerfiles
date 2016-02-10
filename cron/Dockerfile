FROM debian:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::NeverAutoRemove "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Update::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    apt-get update && \
    apt-get install \
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