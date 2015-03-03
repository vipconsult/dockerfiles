# VERSION 1.0
# DOCKER-VERSION  1.2.0
# AUTHOR:         Krasimir Georgiev <support@vip-consult.co.uk>
# DESCRIPTION:    Cron Image Container with php and mysql 

FROM dockerbase/cron

RUN	apt-get update && apt-get install -y --no-install-recommends php5-cli php5-curl php5-mysql
RUN	sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php5/cli/php.ini

# Clean up system
RUN apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

CMD /usr/sbin/cron -f
