# VERSION 1.0
# DOCKER-VERSION  1.2.0
# AUTHOR:         Krasimir Georgiev <support@vip-consult.co.uk>
# DESCRIPTION:    Freeswitch Image Container 

FROM debian:wheezy

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
        make curl wget adduser autoconf automake devscripts gawk g++ git-core ca-certificates \
        libjpeg-dev libncurses5-dev libtool make python-dev gawk pkg-config \
        libtiff5-dev libperl-dev libgdbm-dev libdb-dev gettext libssl-dev \
        libcurl4-openssl-dev libpcre3-dev libspeex-dev libspeexdsp-dev libsqlite3-dev \
        libedit-dev libldns-dev libpq-dev \
# install odbc support 
        unixodbc-dev odbc-postgresql 

RUN cd /usr/src \
    && git clone -b v1.4 https://freeswitch.org/stash/scm/fs/freeswitch.git freeswitch

WORKDIR /usr/src/freeswitch

RUN ./bootstrap.sh -j

ADD ./modules.conf /usr/src/freeswitch/modules.conf

RUN ./configure --enable-core-pgsql-support

RUN cat /usr/src/freeswitch/modules.conf
RUN make && make install \
    && adduser --disabled-password --quiet --system --home /usr/local/freeswitch --gecos "FreeSWITCH Voice Platform" --ingroup daemon freeswitch \
    && chown -R freeswitch:daemon /usr/local/freeswitch/ \
    && chmod -R ug=rwX,o= /usr/local/freeswitch/ \
    && chmod -R u=rwx,g=rx /usr/local/freeswitch/bin/* \
    && ln /usr/local/freeswitch/bin/fs_cli /usr/local/bin/fs_cli

# Clean up system
RUN rm -R /usr/src/freeswitch/ \
    && apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

ENTRYPOINT /usr/local/freeswitch/bin/freeswitch