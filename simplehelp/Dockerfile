FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

#WORKDIR /home
RUN apt-get -y update
#RUN  apt-get install -y wget && wget http://simple-help.com/releases/SimpleHelp-linux-amd64.tar.gz
#RUN tar -zxvf SimpleHelp-linux-amd64.tar.gz  && \
#    rm SimpleHelp-linux-amd64.tar.gz

WORKDIR /home/simplehelp

#RUN sed -i -e "s/&/ /g" serverstart.sh
RUN apt-get install libc6-i386
RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["sh","serverstart.sh"]


