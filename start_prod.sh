# /bin/bash
docker rm -f $(docker ps -aq)


docker run --restart=always -d --name mysql1 -p 127.0.0.1:3306:3306 -v /home/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=aaaa -d vipconsult/mysql

docker run --restart=always -d --name pgsql1 -p 127.0.0.1:5432:5432 -v /home/postgresql:/var/lib/postgresql/data -e PG_LOCALE="en_GB.UTF-8 UTF-8" vipconsult/pgsql93

docker run --restart=always -d --name php53 -v /var/run:/var/run -v /home/http:/home/http  --link mysql1:mysql1  --link pgsql1:pgsql1 vipconsult/php53

docker run --restart=always -d --name php -v /var/run:/var/run -v /home/http:/home/http  --link mysql1:mysql1  --link pgsql1:pgsql1 vipconsult/php

docker run --restart=always -d -v /home/simplehelp:/home/simplehelp  --net=host vipconsult/simplehelp

docker run --restart=always -d -v /home/http:/home/http --name nginx -v /var/run:/var/run -p 178.79.150.62:80:80 -p 178.79.150.62:443:443 vipconsult/nginx nginx -c /home/http/default/main.conf -g "daemon off;"

sudo rmdir /home/proftpd/ftpd.passwd
sudo mkdir -p /home/proftpd
sudo touch /home/proftpd/ftpd.passwd

docker run --restart=always --net=host -d --name proftpd -v /home/http:/home/ -v /home/proftpd/ftpd.passwd:/etc/proftpd/ftpd.passwd vipconsult/proftpd
sleep 5
docker run --restart=always -d -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker michaloo/logrotate
