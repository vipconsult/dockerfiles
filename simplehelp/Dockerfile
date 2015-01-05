FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

WORKDIR /home
RUN apt-get -y update && apt-get install -y wget
RUN wget http://simple-help.com/releases/SimpleHelp-linux-amd64.tar.gz
RUN tar -zxvf SimpleHelp-linux-amd64.tar.gz  && \
    rm SimpleHelp-linux-amd64.tar.gz

WORKDIR /home/SimpleHelp

RUN sed -i -e "s/&/ /g" serverstart.sh

RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["sh","serverstart.sh"]


