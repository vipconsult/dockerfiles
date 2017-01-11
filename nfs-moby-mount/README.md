A Simple Docker image to automate mounting a remote NFS share into the Docker host.

Usage:
```

```

It support all Docker platforms that use the Moby Linux.
  Docker for Mac , 
  Docker for AWS
  Docker for Windows (unsure)

Normally you can't access the host from within the container so we use nsenter to access the host, install the nfs client and mount the shares

In a docker swarm you can use swarm-exec to mount the same nfs share on all nodes to be used as persistant storage from the docker services
swarm-exec docker 
https://github.com/mavenugo/swarm-exec

TOD DO :Demo video

