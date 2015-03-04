FROM debian:wheezy

MAINTAINER Krasimir Georgiev (support@vip-consult.co.uk)

# Set the locale
RUN apt-get update
RUN apt-get install -y locales && locale-gen en_UK.UTF-8
ENV LANG en_UK.UTF-8
ENV LANGUAGE en_UK:en
ENV LC_ALL en_UK.UTF-8

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update\
    && apt-get -y install mysql-client-5.5\
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/mysql"]