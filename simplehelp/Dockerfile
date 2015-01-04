FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

WORKDIR /home
RUN apt-get -y update && apt-get install -y wget
RUN wget http://simple-help.com/releases/SimpleHelp-linux-amd64.tar.gz
RUN tar -zxvf SimpleHelp-linux-amd64.tar.gz  && \
    rm SimpleHelp-linux-amd64.tar.gz && \
    cd SimpleHelp

EXPOSE 80
EXPOSE 443
 
CMD ["sh serverstart.sh"]

