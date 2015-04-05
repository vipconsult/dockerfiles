# /bin/bash
docker rm -f $(docker ps -aq)

sudo docker run --name fs \
        --restart=always -d \
        -v /home/freeswitch/sounds:/usr/local/freeswitch/sounds \
        -v /home/freeswitch/conf:/usr/local/freeswitch/conf \
        --net=host \
        vipconsult/freeswitch

docker run --name psql1 \
        --restart=always -d \
        -p 127.0.0.1:5432:5432 \
        -v /home/postgresql:/var/lib/postgresql/data \
        vipconsult/pgsql93

sudo rmdir /home/proftpd/ftpd.passwd
sudo mkdir -p /home/proftpd
sudo touch /home/proftpd/ftpd.passwd

docker run --name proftpd \
        --restart=always -d \
        --net=host \
        -v /home:/home/ \
        -v /home/proftpd/ftpd.passwd:/etc/proftpd/ftpd.passwd \
        vipconsult/proftpd


docker run --name logrotate \
        --restart=always -d \
        -v /var/lib/docker:/var/lib/docker \
        vipconsult/logrotate

