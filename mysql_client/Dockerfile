FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev (support@vip-consult.co.uk)

# Set the locale
RUN apt-get update
RUN apt-get install locales && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.conf && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV HOME /root

RUN apt-get install mysql-client-5.5 \
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/mysql"]