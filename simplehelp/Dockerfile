FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

# this doesn;t work as the license is for an older simplehelp version so instead we will use a volume from the host for the app
#WORKDIR /home
#RUN  wget http://simple-help.com/releases/SimpleHelp-linux-amd64.tar.gz
#RUN tar -zxvf SimpleHelp-linux-amd64.tar.gz  && \
#    rm SimpleHelp-linux-amd64.tar.gz

RUN apt-get install libc6-i386 && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
WORKDIR /home/simplehelp

CMD ["sh","serverstart.sh"]

