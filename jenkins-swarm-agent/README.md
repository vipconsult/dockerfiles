an image to automate deploying a jenkins swarm agent using docker

https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin

the only requirement is to set a secret like
echo "-master http://10.0.0.101 -password admin -username admin" | docker secret create jenkins -

to set a custom label use -e LABEL=docker-prod
Whitespace-separated list of labels to be assigned for this slave.

the best way to use it is by running containers directly in the container 
the image has a docker client so if you bind mount the host socket you can run containers on the host itself 

docker service create 
	--name jenkins-swarm-agent  
	-e LABELS=docker-production
	--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" 
	--secret source=jenkins-v1,target=jenkins   
	vipconsult/jenkins-swarm-agent
