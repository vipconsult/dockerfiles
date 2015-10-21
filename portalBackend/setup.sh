#!/bin/bash
set -e

sed -i "s/^.*mailhub=.*$/mailhub=$smtpServer/" /etc/ssmtp/ssmtp.conf

if [ -n "$portalIP" ]; then
    echo $portalIP portal.vip-consult.co.uk >> /etc/hosts
fi


cd /go/src/portalBackend
go run main.go jobs.go mail.go webHosting.go

