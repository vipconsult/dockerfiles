#! /bin/bash
sysctl fs.inotify.max_user_watches=300000 > /dev/null 2>&1

sed -i -e "s/.*ListenAddress 0.0.0.0.*/ListenAddress $INTERNAL_IP/" /etc/ssh/sshd_config
sed -i -e "s/.*Port 22.*/Port 222/" /etc/ssh/sshd_config

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
           host ='$LB_SERVER',
           --excludeFrom='/etc/lsyncd.exclude',
           targetdir ='/sync',
           delete = 'running',
           delay = 1,
           rsync = {
             archive = true,
             compress = false,
             whole_file = false
           },
           ssh = {
             port = 222
           }
        }
    " > /etc/lsyncd.conf
