FROM debian:wheezy

MAINTAINER Krasimir Georgiev (support@vip-consult.co.uk)

ENV DEBIAN_FRONTEND noninteractive
# Set the locale
RUN echo deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main >> /etc/apt/sources.list && \
    apt-get update

RUN apt-get install -y --no-install-recommends locales && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.conf && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

RUN apt-get -y --no-install-recommends --force-yes install postgresql-client-9.3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/psql"]