#! /bin/bash
sysctl fs.inotify.max_user_watches=300000 > /dev/null 2>&1

chmod 640 -R /root
chmod 600 -R /etc/ssh
chmod 600 -R /root/.ssh/id_rsa
chmod 600 -R /var/run/sshd

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
           --excludeFrom='/etc/lsyncd.exclude',
           targetdir ='/sync',
           delete = 'running',
           delay = 1,
           rsync = {
             archive = true,
             compress = false,
             whole_file = false
           },
        }
    " > /etc/lsyncd.conf
