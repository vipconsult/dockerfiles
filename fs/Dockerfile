# VERSION 1.0
# Freeswitch Version  1.6
# AUTHOR:         Krasimir Georgiev <support@vip-consult.co.uk>
# DESCRIPTION:    Freeswitch Image Container 

FROM debian:jessie

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget && \
    echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/99FreeSWITCH.test.list && \
    wget -O - http://files.freeswitch.org/repo/deb/freeswitch-1.6/key.gpg |apt-key add -  && \
    apt-get update

RUN DEBIAN_FRONTEND=none APT_LISTCHANGES_FRONTEND=none apt-get install -y --force-yes freeswitch-video-deps-most \
        unixodbc-dev odbc-postgresql \
        libspeex-dev
        #apt-get install -y --no-install-recommends \
        #make curl wget adduser autoconf automake devscripts gawk g++ git-core ca-certificates \
        #libjpeg-dev libncurses5-dev libtool make python-dev gawk pkg-config \
        #libtiff5-dev libperl-dev libgdbm-dev libdb-dev gettext libssl-dev \
        #libcurl4-openssl-dev libpcre3-dev libspeex-dev libspeexdsp-dev libsqlite3-dev \
        #libedit-dev libldns-dev libpq-dev \
        # install odbc support 
    
# because we're in a branch that will go through many rebases it's
# better to set this one, or you'll get CONFLICTS when pulling (update) 
WORKDIR /usr/src
RUN git config --global pull.rebase true && \
    git clone https://freeswitch.org/stash/scm/fs/freeswitch.git freeswitch.git

WORKDIR /usr/src/freeswitch.git
    
RUN ./bootstrap.sh -j

RUN cat modules.conf
ADD ./modules.conf modules.conf
RUN cat modules.conf

RUN ./configure --enable-core-pgsql-support

RUN make && make install

RUN echo "net.core.rmem_max = 16777216" > /etc/sysctl.d/vid.conf && \
    echo "net.core.wmem_max = 16777216" >> /etc/sysctl.d/vid.conf && \
    echo "kernel.core_pattern = core.%p" >> /etc/sysctl.d/vid.conf && \
    ln /usr/local/freeswitch/bin/fs_cli /usr/local/bin/fs_cli && \
    adduser --disabled-password --quiet --system --home /usr/local/freeswitch --gecos "FreeSWITCH Voice Platform" --ingroup daemon freeswitch && \
    chown -R freeswitch:daemon /usr/local/freeswitch/  && \
    chmod -R ug=rwX,o= /usr/local/freeswitch/ && \
    chmod -R u=rwx,g=rx /usr/local/freeswitch/bin/*

# Clean up system
RUN rm -R /usr/src/* \
    && apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

ENTRYPOINT /usr/local/freeswitch/bin/freeswitch