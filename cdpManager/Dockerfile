FROM vipconsult/base:jessie

RUN mkdir -p /tmp/r1soft && \
	cd /tmp/r1soft && \
	wget http://repo.r1soft.com/trials/R1soft-ServerBackup-Manager-SE-linux64.zip && \
	apt-get install unzip && \
	unzip R1soft-ServerBackup-Manager-SE-linux64.zip && \
	dpkg -i r1soft-getmodule-1.0.0-50_amd64.deb && \
	dpkg -i r1soft-docstore-6.2.1-56.x86_64.deb && \
	dpkg -i serverbackup-setup-amd64-6.2.1-56.deb && \
	dpkg -i serverbackup-manager-amd64-6.2.1-56.deb && \
	dpkg -i serverbackup-enterprise-amd64-6.2.1-56.deb && \
	rm -Rf /tmp/r1soft && \
	rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail","-n0", "-F","/usr/sbin/r1soft/log/server.log"]
