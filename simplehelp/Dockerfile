FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get -y update

# this doesn;t work as the licnese is for an older simplehelp version
#WORKDIR /home
#RUN  apt-get install -y wget && wget http://simple-help.com/releases/SimpleHelp-linux-amd64.tar.gz
#RUN tar -zxvf SimpleHelp-linux-amd64.tar.gz  && \
#    rm SimpleHelp-linux-amd64.tar.gz

WORKDIR /home/simplehelp
# otherwise te start script exits at the end causing the contained to exit as well.
#RUN sed -i -e "s/&/ /g" serverstart.sh

RUN apt-get install libc6-i386
RUN apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && apt-get clean

EXPOSE 80
EXPOSE 443

CMD ["sh","serverstart.sh"]

