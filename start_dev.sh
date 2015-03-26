# /bin/bash
docker rm -f $(docker ps -aq)

docker run --restart=always -d --name mysql1 \
	-p 127.0.0.1:3306:3306 \
	-v /home/mysql:/var/lib/mysql \
	-e MYSQL_ROOT_PASSWORD=aaaa \
	vipconsult/mysql

docker run --restart=always -d --name psql1 \
	-p 127.0.0.1:5432:5432 \
	-v /home/postgresql:/var/lib/postgresql/data \
	-e PG_LOCALE="en_GB.UTF-8 UTF-8" \
	vipconsult/pgsql93

docker run --restart=always -d --name php53 \
	-v /var/run:/var/run \
	-v /home/http:/home/http  \
	--link mysql1:mysql1  \
	--link psql1:psql1 \
	-h dev.vip-consult.co.uk \
	vipconsult/php53

docker run --restart=always -d  --name php \
	-v /var/run:/var/run \
	-v /home/http:/home/http  \
	--link mysql1:mysql1  \
	--link psql1:psql1 \
        -h dev.vip-consult.co.uk \
	vipconsult/php

docker run --restart=always -d --name nginx-pagespeed  \
	-v /home/http:/home/http \
	-v /var/run:/var/run \
	-p 80:80 \
	-p 443:443  \
	vipconsult/nginx-pagespeed nginx -c /home/http/default/main.conf -g "daemon off;"

docker run -v /home:/home --name data \
	library/debian:wheezy /bin/bash
sleep 7

docker run \
	-v $(which docker):/docker \
	-v /var/run/docker.sock:/docker.sock \
	-e USER=vipconsult \
	-e GROUP=www-data \
	-e USERID=1002 \
	vipconsult/samba data
