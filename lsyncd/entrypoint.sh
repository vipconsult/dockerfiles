#!/bin/bash
set -e

sysctl fs.inotify.max_user_watches=300000 > /dev/null 2>&1

chmod 640 -R /root
chmod 600 -R /etc/ssh
chmod 600 -R /root/.ssh/id_rsa
chmod 600 -R /var/run/sshd
rm /root/.ssh/known_hosts
touch /root/.ssh/known_hosts


if [ -n "${LSYNCD_exlude}" ]; then
    LSYNCD_exlude="exclude = '$LSYNCD_exlude',"
fi


echo "
        settings {
            --statusFile = '/dev/stdout',
            insist = true,
            logfile = '/dev/stdout',
            nodaemon   = true,
        }

        sync {
           default.rsyncssh,
           source ='/sync',
           host ='$LSYNCD_SERVER',
           $LSYNCD_exlude
           --excludeFrom='/etc/lsyncd.exclude',
           targetdir ='/sync',
           delete = 'running',
           delay = $LSYNCD_delay,
           rsync = {
             archive = true,
             compress = false,
             whole_file = false
           },
        }
    " > /etc/lsyncd.conf

exec "$@"
