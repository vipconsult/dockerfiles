FROM vipconsult/base:jessie
RUN apt-get install \
        wget \
        unzip \
        cmake \
        make \
        g++  \
        liblua5.2-dev \
        lua5.2 \
        rsync  \
        ssh-client \
        openssh-server \
        supervisor && \
## form some reason sshd doesn't create this folder , but it requires it.
    mkdir /var/run/sshd && \
    wget --no-check-certificate https://github.com/axkibe/lsyncd/archive/master.zip && \
    unzip master.zip &&\
    cd lsyncd-master/ &&\
    cmake ./ &&\
    make  &&\
    make install &&\
    apt-get purge wget unzip cmake make g++ &&\
    apt-get autoremove &&\
    rm -rf master.zip lsyncd-master

RUN echo "StrictHostKeyChecking no" >>/etc/ssh/ssh_config


ADD supervisord.conf /etc/supervisor/conf.d/
ADD setup.sh setup.sh
RUN chmod o+x setup.sh
CMD ["/usr/bin/supervisord"]