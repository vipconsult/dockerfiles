FROM vipconsult/base:jessie

RUN mkdir -p /tmp/r1soft && \
	cd /tmp/r1soft && \
	wget http://repo.r1soft.com/trials/ServerBackup-Enterprise-Agent-linux64.zip && \
	apt-get install unzip && \
	apt-get install kmod && \
	unzip ServerBackup-Enterprise-Agent-linux64.zip && \
	cd deb-linux64 && \
	apt-get install linux-headers-`uname -r` 
	# dpkg -i *.deb 
	# serverbackup-setup --get-module 
	# rm -Rf /tmp/r1soft && \
	# rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/r1soft/bin/cdpserver", "/usr/sbin/r1soft/conf/server.conf"]