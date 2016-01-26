FROM vipconsult/base:jessie

RUN mkdir -p /tmp/r1soft && \
	cd /tmp/r1soft && \
	wget http://repo.r1soft.com/trials/R1soft-ServerBackup-Manager-SE-linux64.zip && \
	apt-get install unzip && \
	unzip R1soft-ServerBackup-Manager-SE-linux64.zip && \
	dpkg -i serverbackup-setup-amd64-5.12.1-54.deb && \
	dpkg -i serverbackup-manager-amd64-5.12.1-54.deb && \
	dpkg -i serverbackup-enterprise-amd64-5.12.1-54.deb && \
	rm -Rf /tmp/r1soft && \
	rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/r1soft/bin/cdpserver", "/usr/sbin/r1soft/conf/server.conf"]