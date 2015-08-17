# /bin/bash

if [ "$1" == "" ]; then
	echo "no container name given so restarting all conatiners"
	docker rm -f $(docker ps -aq)
else
	echo "Removing $1"
	docker rm -f $1
fi

cn="mysql1"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run --restart=always -d --name $cn \
		-p 127.0.0.1:3306:3306 \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
		-v /home/mysql:/var/lib/mysql \
		-e MYSQL_ROOT_PASSWORD=root \
		vipconsult/mysql
fi

cn="psql1"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run --restart=always -d --name $cn \
		-p 127.0.0.1:5432:5432 \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
		-v /home/postgresql:/var/lib/postgresql/data \
		-e PG_LOCALE="en_GB.UTF-8 UTF-8" \
		vipconsult/pgsql93
fi

cn="smtp"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run --restart=always -d --name $cn \
		-h dev.vip-consult.co.uk \
		-p 127.0.0.1:25:25 \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
		vipconsult/smtp
fi

cn="php53"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run --restart=always -d --name $cn \
		-v /var/run:/var/run \
		-v /home/http:/home/http  \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
		--link mysql1:mysql1  \
		--link psql1:psql1 \
                --link smtp:smtp \
                -e "smtpServer=smtp" \
		-h dev.vip-consult.co.uk \
		vipconsult/php53
fi

cn="php"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run --restart=always -d  --name $cn \
		-v /var/run:/var/run \
		-v /home/http:/home/http  \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
                --link psql1:psql1 \
		--link mysql1:mysql1  \
		--link smtp:smtp \
                -e "smtpServer=smtp" \
        	-h dev.vip-consult.co.uk \
		vipconsult/php
fi

cn="nginx"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run --restart=always -d --name $cn  \
		-v /home/http:/home/http \
		-v /var/run:/var/run \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
		-p 80:80 \
		-p 443:443  \
		vipconsult/nginx-pagespeed nginx -c /home/http/default/main.conf -g "daemon off;"
fi

cn="fs"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
        sudo docker run --restart=always -d --name $cn \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
                -v /home/telecom/fs_new_layout:/usr/local/freeswitch/conf \
                -v /home/telecom/fs_new_layout/fs_cli.conf:/etc/fs_cli.conf \
                -v /home/telecom/fs_new_layout/odbc.ini:/etc/odbc.ini \
                --net=host \
                vipconsult/freeswitch
fi


#cn="logrotate"
#if [ "$1" == "" ] || [ $1 == $cn ] ;then
#echo "Starting $cn"
#	docker run --restart=always -d --name $cn \
#        	-v /var/lib/docker:/var/lib/docker \
#                -v /etc/localtime:/etc/localtime:ro \
#                -v /etc/timezone:/etc/timezone:ro \
#        	vipconsult/logrotate
#fi

cn="data"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run -v /home:/home --name $cn \
		library/debian:wheezy /bin/bash
	sleep 6
fi

cn="samba-server"
if [ "$1" == "" ] || [ $1 == $cn ] ;then
echo "Starting $cn"
	docker run \
		-v $(which docker):/docker \
		-v /var/run/docker.sock:/docker.sock \
                -v /etc/localtime:/etc/localtime:ro \
                -v /etc/timezone:/etc/timezone:ro \
		-e USER=vipconsult \
		-e GROUP=www-data \
		-e USERID=1001 \
		vipconsult/samba data
fi
