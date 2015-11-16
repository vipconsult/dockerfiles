# AUTHOR:         Krasimir Georgiev <support@vip-consult.co.uk>

FROM dockerbase/cron

RUN apt-get update
RUN apt-get install -y ssmtp

CMD /bin/bash -c 'sed -i "s/^.*mailhub=.*$/mailhub=$SMTP_SERVER/" /etc/ssmtp/ssmtp.conf' && /usr/sbin/cron -f