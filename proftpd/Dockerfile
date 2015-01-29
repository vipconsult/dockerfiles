FROM debian:wheezy
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

RUN apt-get update \
    && apt-get install -y --no-install-recommends proftpd openssl
    
RUN apt-get install openssl \
    && openssl req -x509 -nodes -days 1500 -newkey rsa:1024 \
    -subj "/C=GB/ST=dorset/L=dorset/O=vip-consult.co.uk/OU=IT/CN=vip-consult.co.uk/emailAddress=support@vip-consult.co.uk" \
    -keyout /etc/proftpd/proftpd.pem \
    -out /etc/proftpd/proftpd.pem

ADD proftpd.conf /etc/proftpd/
#RUN apt-get install -y --no-install-recommends nano
#RUN apt-get clean \
#    && rm -rf /var/lib/apt/lists/*
#EXPOSE 20 21 12020 12021 12022 12023 12024 12025

CMD proftpd -n
