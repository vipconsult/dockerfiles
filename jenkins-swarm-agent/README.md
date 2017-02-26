an image to automate deploying a jenkins swarm agent using docker

https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin

the only requirement is that the host has a docker daemon running and you set the jenkins master secret like
echo "-master http://10.0.0.101 -password admin -username admin" | docker secret create jenkins -

to set a custom label use -e LABEL=docker-prod
Whitespace-separated list of labels to be assigned for this slave.

the best way to use it is by running containers directly in the container 
the image has a docker client so if you bind mount the host socket you can run containers on the host itself 

--mode global - ensures that with each additional swarm node your slaves will be added to the jenkins cluster

docker service create 
	--mode global
	--name jenkins-swarm-agent  
	-e LABELS=docker-production
	--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" 
	--secret source=jenkins-v1,target=jenkins   
	vipconsult/jenkins-swarm-agent
