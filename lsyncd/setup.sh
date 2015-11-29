#! /bin/bash
echo ' 
        settings {
        --   #statusFile = "/dev/stdout",
            insist = true,
            logfile = "/dev/stdout",
        }

        sync {
           default.rsyncssh,
           source ="/sync",
           host ="dev.www.fullertreacymoney.com",
           --excludeFrom="/etc/lsyncd.exclude",
           targetdir ="/sync",
           delete = "running",
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
    ' > /etc/lsyncd.conf


