# OVERVIEW

We don't mount the docker executable , but only the docker.sock file. The image installs the latest docker-engine to be used as a client through the docker.sock socket.
the image creation always isntalls the latest docker-engine version to be used as client so normally when the host's docker-engine server is older version it might show an error about API mismatch. The good news is that docker has this nice env variable DOCKER_API_VERSION which allows newer clients to talk to older servers.

the image has an indipendant email sender and it uses the MAILTO=email@domain.com


we use supervisor as the cron requires rsyslog so we need to run rsyslog prior the cron daemon so that is uses the rsyslog to send the logs to /var/log/syslog

you can check the  cron logs using the standard method : docker logs cronContainer

# MANUAL RUN
docker run -d -e DOCKER_API_VERSION=1.23 -e MAILTO=email@domain.com -e CRONTASK_1="0 1 * * *  root docker exec someRunningContainer php /home/http/cron.php" vipconsult/cron


# COMPOSE FILE

	cron:
        image: vipconsult/cron
        volumes:  
            - /var/run/docker.sock:/var/run/docker.sock:ro
        environment:
            - DOCKER_API_VERSION=1.23
            - MAILTO=email@domain.com
            - CRONTASK_1=0 1 * * *  root docker exec someRunningContainer php /home/http/cron.php
            - CRONTASK_2=0 2 * * * 	root docker run someImage bash -c "command1 & command2"
