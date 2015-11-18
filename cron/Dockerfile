FROM dockerbase/cron
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

ENV TERM xterm
ENV DEBIAN_FRONTEND none

RUN echo 'APT::NeverAutoRemove "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Update::AllowUnauthenticated "1";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01usersetting && \
    apt-get update && \
    apt-get install nano
    
RUN apt-get install ssmtp &&  \
    rm -rf /var/lib/apt/lists/* && apt-get clean

CMD /bin/bash -c 'sed -i "s/^.*mailhub=.*$/mailhub=$SMTP_SERVER/" /etc/ssmtp/ssmtp.conf' && /usr/sbin/cron -f