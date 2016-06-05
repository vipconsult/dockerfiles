FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

WORKDIR /home
RUN wget http://backend.simple-help.com/releases/SimpleHelp-linux-amd64.tar.gz
RUN tar -zxvf SimpleHelp-linux-amd64.tar.gz  && \
    rm SimpleHelp-linux-amd64.tar.gz
WORKDIR /home/SimpleHelp
# remove the & sign so that the server doesn't background
RUN sed -i 's/&//g' serverstart.sh   

RUN apt-get update && apt-get install libc6-i386 && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

CMD ["sh","serverstart.sh"]

