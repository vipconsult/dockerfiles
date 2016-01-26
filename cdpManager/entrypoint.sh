#!/bin/bash
set -e


if [ !"$(ls -A /usr/sbin/r1soft/confHost)" ]; then
	cp -RT /usr/sbin/r1soft/conf /usr/sbin/r1soft/confHost
fi
if [ !"$(ls -A /usr/sbin/r1soft/conf)" ]; then
	rm -Rf /usr/sbin/r1soft/conf
	ln -s /usr/sbin/r1soft/confHost /usr/sbin/r1soft/conf
fi


sed -i -e "s/^.*daemonize=.*$/daemonize=false/" /usr/sbin/r1soft/conf/server.conf

if [ -n "${CDP_pass}" ]; then
    /usr/bin/serverbackup-setup --user $CDP_user --pass $CDP_pass > /dev/null
fi

CDPSERVER_INSTALL=/usr/sbin/r1soft/

LIB_PATH=${CDPSERVER_INSTALL}/jre/lib/i386/server:${CDPSERVER_INSTALL}/jre/lib/amd64/server

ulimit -d unlimited  # data segment
ulimit -f unlimited  # file size
ulimit -m unlimited  # max memory size

ulimit -s unlimited # stack size
ulimit -t unlimited # cpu time
ulimit -v unlimited # virtual memory
umask 077

export LD_LIBRARY_PATH=${LIB_PATH}

exec "$@"