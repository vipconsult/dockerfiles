FROM debian:wheezy

MAINTAINER Krasimir Georgiev (support@vip-consult.co.uk)

ENV DEBIAN_FRONTEND noninteractive
# Set the locale
RUN apt-get update
RUN apt-get install -y --no-install-recommends locales && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.conf && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV HOME /root

RUN apt-get -y --no-install-recommends install mysql-client-5.5 \
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/mysql"]