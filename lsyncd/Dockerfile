FROM vipconsult/base
RUN apt-get update
apt-get install -y wget unzip cmake make g++  liblua5.2-dev lua5.2 rsync  ssh-client openssh-server supervisor
wget --no-check-certificate https://github.com/axkibe/lsyncd/archive/master.zip
unzip master.zip

cd lsyncd-master/
cmake ./
make 
make install
apt-get purge unzip cmake make g++
rm -rf master.zip lsyncd-master

start ssh server
start the lsyncd agent

    lsyncd -nodaemon -log Exec CONFIGFILE
ADD supervisord.conf /etc/supervisor/conf.d/
ADD setup.sh setup.sh
CMD ["/usr/bin/supervisord"]
 -v ./keys:/root/.ssh