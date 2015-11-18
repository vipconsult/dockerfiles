FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev (support@vip-consult.co.uk)

RUN apt-get install locales mysql-client-5.5

RUN echo "en_GB.UTF-8 UTF-8" >> /etc/locale.conf && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV HOME /root

ENTRYPOINT ["/usr/bin/mysql"]