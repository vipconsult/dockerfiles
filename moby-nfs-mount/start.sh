#!/bin/sh

# get the shell envs
set -e

# check the the required vars are set
if [ -z "$SERVER" ]; then
    echo "SERVER var not set"
    exit 1
fi

if [ -z "$MOUNT" ]; then
    echo "MOUNT var not set"
    exit 1
fi


# use nsenter to enter the docker host so we can mount the amazon EFS share in the host and all containers will have access to the mounted folder
# install required packages and mount the NFS share using env vars $SERVER and  $MOUNT
# create the $MOUNT dir if it doesn't exist
# and finally run inotifywait which will output all file folder and file operations so we have some basic logging
nsenter -t 1 -m -u -i -n sh -c " \
    apk update && \
    apk add nfs-utils inotify-tools && \
    mkdir -p $MOUNT && \
    mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $SERVER $MOUNT && \
    inotifywait -m $MOUNT \
    "
